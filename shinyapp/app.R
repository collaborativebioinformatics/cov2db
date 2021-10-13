library(shiny)
library(mongolite)
library(ggplot2)

host = "mongodb://sno.cs.rice.edu:27017"
databaseName <- "cov2db"
collectionName <- "annotated_vcf"

loadData <- function(gene) {
    # Connect to the database
    db <- mongo(collection = collectionName,
                url = sprintf(
                    "%s/%s",
                    host,
                    databaseName
                ),
                options = ssl_options(weak_cert_validation = TRUE))
    
    if (gene == "all") {
        data <- db$find(query='{"chromosome": "NC_045512.2"}')
    } else {
        data <- db$find(query=sprintf('{"chromosome": "NC_045512.2", "info_GeneName": "%s"}', gene))
    }
    return(data);
}

# Define UI for application that draws a histogram
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
                       value = "all")),
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
                            value = 0.0,
                            min = 0.0,
                            max = 1.0,
                            step = 0.01)),
        column(3,
               numericInput(inputId = "allele_frequency_max",
                            label = "Maximum allele frequncy",
                            value = 0.0,
                            min = 0.0,
                            max = 1.0,
                            step = 0.01)),
        column(3,
               textInput(inputId = "allele_frequency_min",
                            label = "Reference amino acid",
                            value = "all")),
        column(3,
               textInput(inputId = "allele_frequency_max",
                            label = "Alterantive amino acid",
                            value = "all"))
    ),
               
    
    
    #fluidRow(
    #    column(12,
    #           dataTableOutput('table')
    #    )
    #)
    
    hr(),
    
    #plotOutput('hist_af'),
    plotOutput('hist_type')
    
)

server <- function(input, output) {
    data <- reactive({loadData(gene=input$gene_name)})
    
    output$table <- renderDataTable(data())
    
    #output$hist_af <- renderPlot({
    #    req(data)
    #    ggplot(data(), aes(x=info_af, stat=count)) +
    #        geom_histogram()
             #main="Distribution of allele frequencies",
             #xlab="Allele frequency",
             #ylab="Number of variants")
    #}) 
    
    mut_type_table <- reactive(table(data()["info_SequenceOntology"]))
    
    output$hist_type <- renderPlot({
        req(data)
        barplot(mut_type_table(),
                main="Distribution of mutation types",
                ylab="Number of variants")
    })
}

shinyApp(ui = ui, server = server)
