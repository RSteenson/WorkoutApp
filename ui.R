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
                        knobInput(inputId = "warmup_length", label = "Length of warm-up (M):",
                                  value = 0, min = 0, max = 15, step = 0.5,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        knobInput(inputId = "warmup_number", label = "Number of exercises:",
                                  value = 0, min = 0, max = n_warmup,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        boxPad(
                            color = "blue",
                            htmlOutput("warmup_header"),
                            htmlOutput("warmup_list"),
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
                                   knobInput(inputId = "workout_ex_length", label = "Length of exercise period (S):",
                                             value = 40, min = 1, max = 120, step = 5,
                                             displayPrevious = TRUE, #height = "100px",
                                             lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                            column(6,
                                   knobInput(inputId = "workout_rest_length", label = "Length of rest period (S):",
                                             value = 20, min = 1, max = 120, step = 5,
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
                                   knobInput(inputId = "workout_interim", label = "Length of time between sets (S):",
                                             value = 60, min = 1, max = 120, step = 5,
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

            ),

            #----- Setup cool-down ---------------------------------------------
            box(width=3,
                fluidRow(
                    column(
                        width=12, align="center",
                        boxPad(
                            color = "blue",
                            descriptionBlock(
                                header = "Cool-down",
                                rightBorder = FALSE)),
                        br(),
                        knobInput(inputId = "cooldown_length", label = "Length of cool-down (M):",
                                  value = 0, min = 0, max = 15, step = 0.5,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        knobInput(inputId = "cooldown_number", label = "Number of exercises:",
                                  value = 0, min = 0, max = n_cooldown,
                                  displayPrevious = TRUE, #height = "100px",
                                  lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                        boxPad(
                            color = "blue",
                            htmlOutput("cooldown_header"),
                            htmlOutput("cooldown_list"),
                            actionButton(inputId = "cooldown_go", label = "Choose alternative exercises")
                        )
                    )
                )

            )
        )
    )
)
