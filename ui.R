shinyUI(
    dashboardPagePlus(
        useShinyjs(),
        # Add formatting
        tags$head(
            tags$style(
                ".sidebar-toggle {font-size: 30px; padding: 1px;}",
                ".main-sidebar {padding-top: 75px;}",
                # ".main-header .sidebar-toggle {padding: 0px;}",
                ".main-header .logo {height: 75px;}",
                "i {font-size: 30px; padding: 1px;}", # color: red;
                "hr {border: 2px solid #428bca}"
            )
        ),

        #----- Set header ------------------------------------------------------
        header = dashboardHeaderPlus(
            enable_rightsidebar = TRUE,
            rightSidebarIcon = "gears"
        ),

        #----- Set left sidebar ------------------------------------------------
        sidebar = dashboardSidebar(
            width = "100px",
            sidebarMenu(
                id = "tabs",
                menuItem("", tabName = "Info", icon = icon("info")),
                menuItem("", tabName = "setup", icon = icon("sliders-h")),
                menuItem("", tabName = "workout", icon = icon("dumbbell"))
            )
        ),

        #----- Set right sidebar -----------------------------------------------
        rightsidebar = rightSidebar(
        ),

        #----- Set body --------------------------------------------------------
        body = dashboardBody(

            tabItems(
                #----- Begin info tab ---------------------------------------------
                tabItem(tabName = "Info",
                        fluidRow(
                            column(1
                                   ),
                            column(width=10,
                                   box(width=12,
                                       boxPad(
                                           color = "blue",
                                           htmlOutput("HIIT_header")),
                                       br(),
                                       column(width=6,
                                              h3(tags$b("What...?")),
                                              h4("HIIT workouts are a type of cardiovascular exercise that involve alternating between
                                              exercise periods and rest periods, with a new exercise after each break period. The idea
                                              is to increase your heart rate, then partially recover before the next activity."),
                                              br(),
                                              img(src='hiit.png', align = "center")
                                              ),
                                       column(width=6,
                                              h3(tags$b("Why HIIT?")),
                                              h4("So many reasons... but mainly:"),
                                              h4(tags$ul(
                                              tags$li("They're a great way to fit a workout into a short space of time, keep you engaged as
                                              the pace is continually changing, and give you a boost of energy!"),
                                              tags$li("Even by doing only 20 minutes of HIIT, you can improve your fitness and strength."),
                                              tags$li("The only real trade-off is that you need to work at a high enough intensity (i.e.
                                                      push yourself) to compensate for the shorter workout time.")))
                                       )
                                   )
                                   ),
                            column(1
                                    )
                            )
                        ),
                #----- Begin setup tab ---------------------------------------------
                tabItem(tabName = "setup",

                        #----- Add action button
                        fluidRow(
                            column(width=12, align="center",
                                   actionBttn(inputId = "move_to_workout", label = "Go to Workout",
                                              style = "simple", color = "primary", size="lg"
                                   ))
                        ),
                        br(),

                        #----- Setup warm-up
                        box(width=3,
                            fluidRow(
                                column(
                                    width=12, align="center",
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("WU_header")),
                                    br(),
                                    knobInput(inputId = "warmup_length", label = "Length of warm-up (M):",
                                              value = 0, min = 0, max = 15, step = 0.5,
                                              displayPrevious = TRUE, height = "80px",
                                              lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                                    knobInput(inputId = "warmup_number", label = "Number of exercises:",
                                              value = 0, min = 0, max = n_warmup,
                                              displayPrevious = TRUE, height = "80px",
                                              lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("warmup_header"),
                                        htmlOutput("warmup_list"),
                                        br(),
                                        actionButton(inputId = "warmup_go", label = "Choose alternative exercises")
                                    )
                                )
                            )

                        ),

                        #----- Setup workout
                        box(width=6,
                            fluidRow(
                                column(
                                    width=12, align="center",
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("WO_header")),
                                    br(),
                                    fluidRow(
                                        column(6,
                                               knobInput(inputId = "workout_ex_length", label = "Length of exercise period (S):",
                                                         value = 40, min = 1, max = 120, step = 5,
                                                         displayPrevious = TRUE, height = "80px",
                                                         lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                                        column(6,
                                               knobInput(inputId = "workout_rest_length", label = "Length of rest period (S):",
                                                         value = 20, min = 1, max = 120, step = 5,
                                                         displayPrevious = TRUE, height = "80px",
                                                         lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"))
                                    ),
                                    fluidRow(
                                        column(4,
                                               knobInput(inputId = "workout_number", label = "Number of exercises:",
                                                         value = 5, min = 1, max = n_exercises,
                                                         displayPrevious = TRUE, height = "80px",
                                                         lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                                        column(4,
                                               knobInput(inputId = "workout_sets", label = "Number of sets:",
                                                         value = 2, min = 1, max = 10,
                                                         displayPrevious = TRUE, height = "80px",
                                                         lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA")),
                                        column(4,
                                               knobInput(inputId = "workout_interim", label = "Length between sets (S):",
                                                         value = 60, min = 1, max = 120, step = 5,
                                                         displayPrevious = TRUE, height = "80px",
                                                         lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"))
                                    ),
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("workout_header"),
                                        htmlOutput("workout_list"),
                                        br(),
                                        actionButton(inputId = "workout_go", label = "Choose alternative exercises")
                                    )
                                )
                            )

                        ),

                        #----- Setup cool-down
                        box(width=3,
                            fluidRow(
                                column(
                                    width=12, align="center",
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("CD_header")),
                                    br(),
                                    knobInput(inputId = "cooldown_length", label = "Length of cool-down (M):",
                                              value = 0, min = 0, max = 15, step = 0.5,
                                              displayPrevious = TRUE, height = "80px",
                                              lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                                    knobInput(inputId = "cooldown_number", label = "Number of exercises:",
                                              value = 0, min = 0, max = n_cooldown,
                                              displayPrevious = TRUE, height = "80px",
                                              lineCap = "round", fgColor = "#428BCA", inputColor = "#428BCA"),
                                    boxPad(
                                        color = "blue",
                                        htmlOutput("cooldown_header"),
                                        htmlOutput("cooldown_list"),
                                        br(),
                                        actionButton(inputId = "cooldown_go", label = "Choose alternative exercises")
                                    )
                                )
                            )
                        )
                ),

                #----- Begin workout tab ---------------------------------------
                tabItem(tabName = "workout",
                        fluidRow(
                            column(width=3, align="center",
                                   br(), br(),
                                   actionBttn(inputId = "start_workout", label = "Start",
                                              style = "simple", color = "primary", size="lg"),
                                   actionBttn(inputId = "pause_workout", label = "Pause",
                                              style = "simple", color = "primary", size="lg"),
                                   br(), br(),
                                   htmlOutput("total_time_remaining"),
                                   br(),
                                   # htmlOutput("total_time"),
                                   # htmlOutput("warmup_time_remaining"),
                                   # htmlOutput("workout_time_remaining"),
                                   # htmlOutput("cooldown_time_remaining"),
                                   plotOutput("timer_plot", height="200px", width="200px"),
                                   br(), br(),
                                   actionBttn(inputId = "return_setup", label = "Go back to setup",
                                              style = "simple", color = "primary", size="lg"),
                                   br()
                            ),
                            column(width=6, align="center",
                                   br(), br(),
                                   htmlOutput("current_ex_timer")
                                   ),
                            column(width=3, align="center",
                                   br(), br(), br(), br(), br(), br(),
                                   htmlOutput("next_exercise")
                                   )
                        ),
                        fluidRow(
                            column(width=12, align="center",
                                   hr(),
                                   tableOutput("all_exercises")
                                   )
                        )
                        # textOutput("ex_time_remaining")

                )
            )
        )
    )
)
