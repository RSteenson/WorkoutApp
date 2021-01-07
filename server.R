shinyServer(function(input, output, session) {

    #----- Set headings with HMTL ----------------------------------------------
    output$WU_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Warm-up</span>")))
    output$WO_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Workout</span>")))
    output$CD_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Cool-down</span>")))

    #----- Set warm-up ---------------------------------------------------------

    # Create reactive values object
    WU_rv <- reactiveValues(length = "", exercises = "")

    # Observe changes to the length of the warm-up
    WU_length = reactive({
        wu_length = seconds_to_period(input$warmup_length * 60)
        wu_length
    })
    WU_ex_length = reactive({
        if(input$warmup_length > 0 & input$warmup_number > 0){
            wu_ex_length = round((input$warmup_length * 60) / input$warmup_number, digits=0)
            wu_ex_length = seconds_to_period(wu_ex_length)
        } else {
            wu_ex_length = "0S"
        }
        wu_ex_length
    })
    observe({
        WU_rv$length <- paste0("<span style='font-size: 20px'>", WU_length(), "</span><br>",
                               "<span style='font-size: 18px'>", input$warmup_number, " exercises of ", WU_ex_length(), " each</span>")
    })

    # Observe changes to the number of warm-up exercises
    observe({
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- paste0("<span style='font-size: 16px'><br>", paste0(warmup$Exercise, collapse = "<br>"), "<br></span>")
    })

    # If length of warm-up is set to 0, reset exercise list
    # observeEvent(input$warmup_length == 0, {
    #     WU_rv$exercises <- ""
    # })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$warmup_go, {
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- paste0("<span style='font-size: 16px'><br>", paste0(warmup$Exercise, collapse = "<br>"), "<br></span>")
    })

    # Create outputs
    output$warmup_header <- renderUI(HTML(WU_rv$length))
    output$warmup_list <- renderUI(HTML(WU_rv$exercises))

    #----- Set workout ---------------------------------------------------------

    # Create reactive values object
    WO_rv <- reactiveValues(length = "", exercises = "")

    # Observe changes to the total length of the main workout
    WO_length = reactive({
        set_length = input$workout_number * (input$workout_ex_length + input$workout_rest_length)
        total_length = (set_length * input$workout_sets) + (input$workout_interim * (input$workout_sets - 1))
        total_length = seconds_to_period(total_length)
        total_length
    })
    observe({
        WO_rv$length <- paste0("<span style='font-size: 20px'>", WO_length(), "</span><br>",
                               "<span style='font-size: 18px'>", input$workout_sets, " sets of ", input$workout_number, " exercises @ ",
                               input$workout_ex_length, "s work : ", input$workout_rest_length, "s rest</span>")
    })

    # Observe changes to the number of workout exercises
    observe({
        workout <- set_exercises(n_ex = input$workout_number)
        WO_rv$exercises <- paste0("<p style='font-size: 16px'><br>", paste0(workout$Exercise, collapse = "<br>"), "<br></p>")
    })

    # If user clicks button, reselect workout exercises
    observeEvent(input$workout_go, {
        workout <- set_exercises(n_ex = input$workout_number)
        WO_rv$exercises <- paste0("<p style='font-size: 16px'><br>", paste0(workout$Exercise, collapse = "<br>"), "<br></p>")
    })

    # Create outputs
    output$workout_header <- renderUI(HTML(WO_rv$length))
    output$workout_list <- renderUI(HTML(WO_rv$exercises))

    #----- Set cool-down -------------------------------------------------------

    # Create reactive values object
    CD_rv <- reactiveValues(length = "", exercises = "")

    # Observe changes to the length of the warm-up
    CD_length = reactive({
        cd_length = seconds_to_period(input$cooldown_length * 60)
        cd_length
    })
    CD_ex_length = reactive({
        if(input$cooldown_length > 0 & input$cooldown_number > 0){
            cd_ex_length = round((input$cooldown_length * 60) / input$cooldown_number, digits=0)
            cd_ex_length = seconds_to_period(cd_ex_length)
        } else {
            cd_ex_length = "0M 0S"
        }
        cd_ex_length
    })
    observe({
        CD_rv$length <- paste0("<span style='font-size: 20px'>", CD_length(), "</span><br>",
                               "<span style='font-size: 18px'>", input$cooldown_number, " exercises of ", CD_ex_length(), "</span>")
    })

    # Observe changes to the number of warm-up exercises
    observe({
        cooldown <- set_exercises(n_ex = input$cooldown_number, cooldown = TRUE, type = NULL)
        CD_rv$exercises <- paste0("<p style='font-size: 16px'><br>", paste0(cooldown$Exercise, collapse = "<br>"), "<br></p>")
    })

    # If length of warm-up is set to 0, reset exercise list
    # observeEvent(input$warmup_length == 0, {
    #     WU_rv$exercises <- ""
    # })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$cooldown_go, {
        cooldown <- set_exercises(n_ex = input$cooldown_number, cooldown = TRUE, type = NULL)
        CD_rv$exercises <- paste0("<p style='font-size: 16px'><br>", paste0(cooldown$Exercise, collapse = "<br>"), "<br></p>")
    })

    # Create outputs
    output$cooldown_header <- renderUI(HTML(CD_rv$length))
    output$cooldown_list <- renderUI(HTML(CD_rv$exercises))

    #----- Set checks for selected inputs --------------------------------------

    # Create a confirmation box for moving to the workout page
    observeEvent(input$move_to_workout, {
        confirmSweetAlert(
            session,
            inputId = "WO_confirmation",
            title = "Ready to workout?",
            text = tags$b(icon("dumbbell"), style = "color: #3a5fcd;"),
            type = "question",
            btn_labels = c("Cancel", "Confirm"),
            btn_colors = NULL,
            closeOnClickOutside = FALSE,
            showCloseButton = FALSE,
            html = TRUE
        )
    })

    # Switch tabs following a confirm button
    observeEvent(input$WO_confirmation, {
        if(input$WO_confirmation == TRUE){
            updateTabItems(session, "tabs", "workout")
        }
    })

    #----- Create outputs for workout page -------------------------------------

    # Setup reactive values for timers
    timer = reactiveValues(total_length = 0, time_remaining = 0,
                           warmup_remaining = 0, workout_remaining = 0, cooldown_remaining = 0,
                           timer_active = FALSE)

    # Calculate the total time
    total_time = reactive({
        tt = 0
        if(input$warmup_length > 0){
            tt = tt + (input$warmup_length * 60)
        }
        if(WO_length() > 0){
            tt = tt + ((input$workout_number * (input$workout_ex_length + input$workout_rest_length) *
                           input$workout_sets) + (input$workout_interim * (input$workout_sets - 1)))
        }
        if(input$cooldown_length > 0){
            tt = tt + (input$cooldown_length * 60)
        }
        tt
    })

    # Calculate the workout time
    workout_time = reactive({
        wot = 0
        if(WO_length() > 0){
            wot = wot + ((input$workout_number * (input$workout_ex_length + input$workout_rest_length) *
                            input$workout_sets) + (input$workout_interim * (input$workout_sets - 1)))
        }
        wot
    })

    # Set the timer reactive values based on user input
    observe({
        timer$total_length = total_time()
        timer$time_remaining = total_time()
        timer$workout_remaining = workout_time()
        timer$warmup_remaining = (input$warmup_length * 60)
        timer$cooldown_remaining = (input$cooldown_length * 60)
            })

    # Output the total time & times for each part
    output$total_time <- renderUI({
        HTML(paste0("<span style='font-size: 18px'>Total workout length: ", seconds_to_period(timer$total_length), "</span>"))
    })

    # Output the time left.
    output$total_time_remaining <- renderUI({
        HTML(paste0("<span style='font-size: 18px'>Total time left: ", seconds_to_period(timer$time_remaining), "</span>"))
    })
    output$warmup_time_remaining <- renderUI({
        HTML(paste0("<span style='font-size: 18px'>Warmup remaining: ", seconds_to_period(timer$warmup_remaining), "</span>"))
    })
    output$workout_time_remaining <- renderUI({
        HTML(paste0("<span style='font-size: 18px'>Workout remaining: ", seconds_to_period(timer$workout_remaining), "</span>"))
    })
    output$cooldown_time_remaining <- renderUI({
        HTML(paste0("<span style='font-size: 18px'>Cooldown remaining: ", seconds_to_period(timer$cooldown_remaining), "</span>"))
    })

    # Create plot for output visualisation
    output$timer_plot <- renderPlot({
        invalidateLater(1000, session) # Refresh the chart every second
        # Identify times
        t <- timer$total_length
        r <- timer$time_remaining
        e <- t - r
        wu <- timer$warmup_remaining
        wo <- timer$workout_remaining
        cd <- timer$cooldown_remaining
        # Create df of times
        df <- data.frame(status = c("elapsed", "remaining_warmup", "remaining_workout", "remaining_cooldown"),
                         seconds = c(e, wu, wo, cd))
        df$fraction <- df$seconds/t
        df$ymax = cumsum(df$fraction)
        df$ymin = c(0, df$ymax[1], df$ymax[2], df$ymax[3])
        # Produce plot
        p = ggplot(df, aes(fill = status, ymax = ymax, ymin = ymin, xmax = 4, xmin = 2)) +
            geom_rect(fill=c("#ECF0F5", "red", "#428bca", "green")) + # colour="grey30", size=2
            coord_polar(theta="y") +
            xlim(c(0, 4)) +
            theme_void() +
            theme(panel.background = element_rect(fill = "#ECF0F5", color = "#ECF0F5"))
        p
    })

    # observer that invalidates every second. If timer is active, decrease by one.
    observe({
        invalidateLater(1000, session)
        isolate({
            # If timer is active, reduce all times by 1
            if(timer$timer_active == TRUE){
                # Calculate new total time remaining
                timer$time_remaining = timer$time_remaining -1

                # If warm-up timer is finished, move onto subtracting from workouut timer
                if(timer$warmup_remaining > 0){
                    timer$warmup_remaining = timer$warmup_remaining -1
                } else if (timer$warmup_remaining == 0 & timer$workout_remaining > 0){
                    timer$workout_remaining = timer$workout_remaining -1
                } else if (timer$workout_remaining == 0){
                    timer$cooldown_remaining = timer$cooldown_remaining -1
                }

                # If time remaining is 0, switch timer back to being inactive
                if(timer$time_remaining < 1){
                    timer$timer_active = FALSE
                    showModal(modalDialog(
                        title = "Important message",
                        "Workout completed!"))
                }
            }
        })
    })

    # Observers for action buttons
    observeEvent(input$start_workout, {
        timer$timer_active = TRUE
        })
    observeEvent(input$pause_workout, {
        timer$timer_active = FALSE
        })

    #---- Create system to return to setup page --------------------------------

    # Create a confirmation box for moving to the workout page
    observeEvent(input$return_setup, {
        confirmSweetAlert(
            session,
            inputId = "setup_confirmation",
            title = "Are you sure you want to return to setup?",
            text = tags$b(icon("sliders-h"), style = "color: #3a5fcd;"),
            type = "question",
            btn_labels = c("Cancel", "Confirm"),
            btn_colors = NULL,
            closeOnClickOutside = FALSE,
            showCloseButton = FALSE,
            html = TRUE
        )
    })

    # Switch tabs following a confirm button
    observeEvent(input$setup_confirmation, {
        if(input$setup_confirmation == TRUE){
            updateTabItems(session, "tabs", "setup")
        }
    })

    # Create sweet alert for alerting when workout exercises are not selected
    # observeEvent(input$warning, {
    #     sendSweetAlert(
    #         session = session,
    #         title = "Warning !!!",
    #         text = NULL,
    #         type = "warning"
    #     )
    # })
    # warmup %>%
    #     select(Exercise, Description) %>%
    #     kable(col.names = NULL, escape = FALSE) %>%
    #     kable_styling(bootstrap_options = "condensed", full_width = TRUE, font_size = 18) %>%
    #     column_spec(1, bold = TRUE, border_right = TRUE) %>%
    #     column_spec(2, italic = TRUE)

    })
