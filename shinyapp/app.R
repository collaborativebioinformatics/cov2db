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
    img(src='assets/cov2db_logo_bg.pnh', align = "center"),
    
    #fluidRow(
    #    column(12,
    #           dataTableOutput('table')
    #    )
    #)
    
    textInput(inputId = "gene_name",
              label = "Gene of interest (or all)",
              value = "all"),
    
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
