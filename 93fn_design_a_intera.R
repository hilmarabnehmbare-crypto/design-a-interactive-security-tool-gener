# 93fn_design_a_intera.R

# Load required libraries
library(shiny)
library(DT)

# Define the UI
ui <- fluidPage(
  titlePanel("Interactive Security Tool Generator"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("tool_name", "Tool Name:", ""),
      selectInput("tool_type", "Tool Type:", c("Firewall", "IDS", "VPN")),
      numericInput("num_rules", "Number of Rules:", 1, min = 1, max = 10),
      actionButton("generate_tool", "Generate Tool")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tool Configuration", DT::dataTableOutput("tool_config")),
        tabPanel("Generated Tool", textOutput("generated_tool"))
      )
    )
  )
)

# Define the server
server <- function(input, output) {
  tool_config <- eventReactive(input$generate_tool, {
    data.frame(
      Rule = paste("Rule", 1:input$num_rules),
      Source = rep("Any", input$num_rules),
      Destination = rep("Any", input$num_rules),
      Protocol = rep("TCP", input$num_rules),
      Action = rep("Allow", input$num_rules)
    )
  })
  
  output$tool_config <- DT::renderDataTable({
    tool_config()
  })
  
  generated_tool <- eventReactive(input$generate_tool, {
    tool_code <- ""
    tool_code <- paste0(tool_code, "# ", input$tool_name, "\n")
    tool_code <- paste0(tool_code, "tool_type = ", input$tool_type, "\n")
    tool_code <- paste0(tool_code, "num_rules = ", input$num_rules, "\n")
    tool_code <- paste0(tool_code, "\n")
    
    for (i in 1:input$num_rules) {
      rule <- paste("rule_", i, sep = "")
      tool_code <- paste0(tool_code, rule, " = {\n")
      tool_code <- paste0(tool_code, "  source = Any;\n")
      tool_code <- paste0(tool_code, "  destination = Any;\n")
      tool_code <- paste0(tool_code, "  protocol = TCP;\n")
      tool_code <- paste0(tool_code, "  action = Allow;\n")
      tool_code <- paste0(tool_code, "}\n")
    }
    
    tool_code
  })
  
  output$generated_tool <- renderText({
    generated_tool()
  })
}

# Run the application
shinyApp(ui = ui, server = server)