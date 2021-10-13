library(shiny)
library(mongolite)
library(ggplot2)

host = "mongodb://sno.cs.rice.edu:27017"
databaseName <- "cov2db"
collectionName <- "annotated_vcf"

loadData <- function(gene, min_af, max_af, pos, mtype, pchange, impact) {
    # Connect to the database
    db <- mongo(collection = collectionName,
                url = sprintf(
                    "%s/%s",
                    host,
                    databaseName
                ),
                options = ssl_options(weak_cert_validation = TRUE))
    
    query <- '{"chromosome": "NC_045512.2"'
    if (gene != "all") {
        query <- sprintf('%s, "info_GeneName": "%s"', query, gene)
    }
    if (pos != -1) {
        query <- sprintf('%s, "start": %s', query, pos)
    }
    if (mtype != "all") {
        query <- sprintf('%s, "info_SequenceOntology": "%s"', query, mtype)
    }
    if (pchange != "all") {
        query <- sprintf('%s, "info_ProteinChange": "%s"', query, pchange)
    }
    if (impact != "all") {
        query <- sprintf('%s, "info_PutativeImpact": "%s"', query, impact)
    }
    query <- sprintf('%s, "info_af": {"$gte": %s}, "info_af": {"$lte": %s}', query, min_af, max_af)
    query <- sprintf('%s}', query)
    data <- db$find(query=query)
    return(data);
}

ui <- fluidPage(
    fluidRow(
        column(3, 
               img(src='cov2db_logo_bg.png', width="100%", align="center"))
        ),
    hr(),
    fluidRow(
        column(3, h2("Data filters")),
        column(3,
               textInput(inputId = "gene_name",
                       label = "Gene of interest (or all)",
                       value = "S")),
        column(3,
               textInput(inputId = "mutation_type",
                         label = "Mutation type (or all)",
                         value = "all")),
        column(3,
               numericInput(inputId = "position_nt",
                            label = "Position (nucleotide)",
                            value = -1,
                            min = -1,
                            max = 30000,
                            step = 1))
        ),
    fluidRow(
        column(3,
               numericInput(inputId = "allele_frequency_min",
                            label = "Minimum allele frequncy",
                            value = 0.05,
                            min = 0.0,
                            max = 1.0,
                            step = 0.01)),
        column(3,
               numericInput(inputId = "allele_frequency_max",
                            label = "Maximum allele frequncy",
                            value = 1.0,
                            min = 0.0,
                            max = 1.0,
                            step = 0.01)),
        column(3,
               textInput(inputId = "protein_change",
                            label = "Amino acid change",
                            value = "all")),
        column(3,
               textInput(inputId = "putative_impact",
                            label = "Putative impact",
                            value = "all"))
    ),

    hr(),
    
    plotOutput('hist_type'),
    
    hr(),
    
    dataTableOutput('table')
    
)

server <- function(input, output) {
    data <- reactive({d <- loadData(gene=input$gene_name, 
                                    min_af=input$allele_frequency_min,
                                    max_af=input$allele_frequency_max,
                                    pos=input$position_nt,
                                    mtype=input$mutation_type,
                                    pchange=input$protein_change,
                                    impact=input$putative_impact)
                      d$info_ann <- NULL
                      d$chromosome <- NULL
                      d$id <- NULL
                      d$filter <- NULL
                      return(d)})
    
    output$table <- renderDataTable(data())
    
    mut_type_table <- reactive(table(data()["info_SequenceOntology"]))
    
    output$hist_type <- renderPlot({
        req(data)
        barplot(mut_type_table(),
                main="Distribution of mutation types",
                ylab="Number of variants",
                col=rgb(0.2,0.4,0.6,0.8),
                cex.axis=2,
                cex.lab=1.5,
                cex.names=1.2,
                cex.main=2)
    })
}

shinyApp(ui = ui, server = server)
