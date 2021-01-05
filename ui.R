shinyUI(
    dashboardPagePlus(

        #----- Set header ------------------------------------------------------
        header = dashboardHeaderPlus(
            enable_rightsidebar = TRUE,
            rightSidebarIcon = "gears"
        ),

        #----- Set left sidebar ------------------------------------------------
        sidebar = dashboardSidebar(
            collapsed = TRUE
        ),

        #----- Set right sidebar -----------------------------------------------
        rightsidebar = rightSidebar(
            background = "dark"
        ),

        #----- Set body --------------------------------------------------------
        body = dashboardBody(

            #----- Setup warm-up -----------------------------------------------
            box(width=3,
                fluidRow(
                    column(
                        width=12, align="center",
                        boxPad(
                            color = "blue",
                            descriptionBlock(
                                header = "Warm-up",
                                rightBorder = FALSE)),
                        br(),
                        knobInput(inputId = "warmup_length", label = "Length of warm-up (mins):",
                                  value = 0, min = 0, max = 15,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        knobInput(inputId = "warmup_number", label = "Number of exercises:",
                                  value = 0, min = 0, max = n_warmup,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        boxPad(
                            color = "blue",
                            descriptionBlock(
                                header = textOutput("warmup_header"),
                                text = htmlOutput("warmup_list"),
                                rightBorder = FALSE),
                            actionButton(inputId = "warmup_go", label = "Choose alternative exercises")
                        )
                    )
                )

            ),

            #----- Setup workout -----------------------------------------------
            box(width=6,
                fluidRow(
                    column(
                        width=12, align="center",
                        boxPad(
                            color = "blue",
                            descriptionBlock(
                                header = "Workout",
                                rightBorder = FALSE)),
                        br(),
                        fluidRow(
                            column(6,
                                   knobInput(inputId = "workout_ex_length", label = "Length of exercise period (s):",
                                             value = 40, min = 1, max = 120,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                            column(6,
                                   knobInput(inputId = "workout_rest_length", label = "Length of rest period (s):",
                                             value = 20, min = 1, max = 120,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"))
                        ),
                        fluidRow(
                            column(4,
                                   knobInput(inputId = "workout_number", label = "Number of exercises:",
                                             value = 5, min = 1, max = n_exercises,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                            column(4,
                                   knobInput(inputId = "workout_sets", label = "Number of sets:",
                                             value = 2, min = 1, max = 10,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                            column(4,
                                   knobInput(inputId = "workout_interim", label = "Length of time between sets (s):",
                                             value = 60, min = 1, max = 120,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"))
                        ),
                        boxPad(
                            color = "blue",
                            htmlOutput("workout_header"),
                            htmlOutput("workout_list"),
                            actionButton(inputId = "workout_go", label = "Choose alternative exercises")
                        )
                    )
                )

            )
            #----- Setup cool-down ---------------------------------------------

        )
    )
)
