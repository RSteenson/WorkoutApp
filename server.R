shinyServer(function(input, output, session) {

    #----- Set headings with HMTL ----------------------------------------------
    output$WU_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Warm-up</span>")))
    output$WO_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Workout</span>")))
    output$CD_header = renderUI(HTML(paste0("<span style='font-size: 22px; font-weight: bold'>Cool-down</span>")))

    #----- Set warm-up ---------------------------------------------------------

    # Create reactive values object
    WU_rv <- reactiveValues(length = c(), exercises = c(), descriptions=c())

    # Observe changes to the length of the warm-up
    WU_length = reactive({
        input$warmup_length * 60
    })
    WU_ex_length = reactive({
        if(input$warmup_length > 0 & input$warmup_number > 0){
            wu_ex_length = round((input$warmup_length * 60) / input$warmup_number, digits=0)
        } else {
            wu_ex_length = 0
        }
        wu_ex_length
    })
    observe({
        WU_rv$length <- paste0("<span style='font-size: 20px'>", seconds_to_period(WU_length()), "</span><br>",
                               "<span style='font-size: 18px'>", input$warmup_number, " exercises of ", seconds_to_period(WU_ex_length()), " each</span>")
    })

    # Observe changes to the number of warm-up exercises
    observe({
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- warmup$Exercise
        WU_rv$descriptions <- warmup$Description
    })

    # If length of warm-up is set to 0, reset exercise list
    # observeEvent(input$warmup_length == 0, {
    #     WU_rv$exercises <- ""
    # })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$warmup_go, {
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- warmup$Exercise
        WU_rv$descriptions <- warmup$Description
    })

    # Create outputs
    output$warmup_header <- renderUI(HTML(WU_rv$length))
    output$warmup_list <- renderUI(HTML(paste0("<span style='font-size: 16px'><br>", paste0(WU_rv$exercises, collapse = "<br>"), "<br></span>")))

    #----- Set workout ---------------------------------------------------------

    # Create reactive values object
    WO_rv <- reactiveValues(length = c(), exercises = c(), descriptions=c())

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
        WO_rv$exercises <- workout$Exercise
        WO_rv$descriptions <- workout$Description
    })

    # If user clicks button, reselect workout exercises
    observeEvent(input$workout_go, {
        workout <- set_exercises(n_ex = input$workout_number)
        WO_rv$exercises <- workout$Exercise
        WO_rv$descriptions <- workout$Description
    })

    # Create outputs
    output$workout_header <- renderUI(HTML(WO_rv$length))
    output$workout_list <- renderUI(HTML(paste0("<p style='font-size: 16px'><br>", paste0(WO_rv$exercises, collapse = "<br>"), "<br></p>")))

    #----- Set cool-down -------------------------------------------------------

    # Create reactive values object
    CD_rv <- reactiveValues(length = c(), exercises = c(), descriptions=c())

    # Observe changes to the length of the warm-up
    CD_length = reactive({
        cd_length = seconds_to_period(input$cooldown_length * 60)
        cd_length
    })
    CD_ex_length = reactive({
        if(input$cooldown_length > 0 & input$cooldown_number > 0){
            cd_ex_length = round((input$cooldown_length * 60) / input$cooldown_number, digits=0)
            cd_ex_length = cd_ex_length
        } else {
            cd_ex_length = 0
        }
        cd_ex_length
    })
    observe({
        CD_rv$length <- paste0("<span style='font-size: 20px'>", CD_length(), "</span><br>",
                               "<span style='font-size: 18px'>", input$cooldown_number, " exercises of ", seconds_to_period(CD_ex_length()), "</span>")
    })

    # Observe changes to the number of warm-up exercises
    observe({
        cooldown <- set_exercises(n_ex = input$cooldown_number, cooldown = TRUE, type = NULL)
        CD_rv$exercises <- cooldown$Exercise
        CD_rv$descriptions <- cooldown$Description
    })

    # If length of warm-up is set to 0, reset exercise list
    # observeEvent(input$warmup_length == 0, {
    #     WU_rv$exercises <- ""
    # })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$cooldown_go, {
        cooldown <- set_exercises(n_ex = input$cooldown_number, cooldown = TRUE, type = NULL)
        CD_rv$exercises <- cooldown$Exercise
        CD_rv$descriptions <- cooldown$Description
    })

    # Create outputs
    output$cooldown_header <- renderUI(HTML(CD_rv$length))
    output$cooldown_list <- renderUI(HTML(paste0("<p style='font-size: 16px'><br>", paste0(CD_rv$exercises, collapse = "<br>"), "<br></p>")))

    #----- Switch tabs ---------------------------------------------------------

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

    #----- Create timers for workout page --------------------------------------

    # Setup reactive values for timers
    timer = reactiveValues(total_length = 0, time_remaining = 0,
                           ex_countdown_seq = 0, ex_seq_n = 1, current_ex_time = 0,
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

    #----- Create outputs for workout page -------------------------------------

    # Create dataframe with all exercises
    full_ex_list <- reactive({
        all_ex <- data.frame()
        if(input$warmup_number > 0){
            # Create dataframe from objects
            WU_df = data.frame(Type="Warm-up",
                               Exercise = WU_rv$exercises,
                               Description = WU_rv$descriptions,
                               ex_time = WU_ex_length())
            all_ex <- rbind(all_ex, WU_df)
        }
        if(input$workout_number > 0){
            # Create dataframe from objects
            WO_df = data.frame(Type="Workout",
                               Exercise = WO_rv$exercises,
                               Description = WO_rv$descriptions,
                               ex_time = input$workout_ex_length)
            # Add in rest periods between
            if(input$workout_rest_length > 0){
                for(i in 1:nrow(WO_df)){
                    WO_df_sub <- rbind(WO_df[i,],
                                       data.frame(Type="Break",
                                                  Exercise="Break",
                                                  Description="",
                                                  ex_time=30))
                    if(i==1){
                        WO_br_df <- WO_df_sub
                    } else {
                        WO_br_df <- rbind(WO_br_df, WO_df_sub)
                    }
                }
            }
            all_ex <- rbind(all_ex, WO_br_df)
        }
        if(input$cooldown_number > 0){
            # Create dataframe from objects
            CD_df = data.frame(Type="Cool-down",
                               Exercise = CD_rv$exercises,
                               Description = CD_rv$descriptions,
                               ex_time = CD_ex_length())
            all_ex <- rbind(all_ex, CD_df)
        }
        # Add info on next exercise for non-break rows
        all_ex$next_ex <- ""
        ex_rows = which(all_ex$Type != "Break")
        for(i in ex_rows){
            if(i == ex_rows[length(ex_rows)]){
                all_ex$next_ex[i] <- ""
            } else if(all_ex$Type[i] %in% c("Warm-up", "Cool-down")){
                all_ex$next_ex[i] <- all_ex$Exercise[i+1]
            } else {
                all_ex$next_ex[i] <- all_ex$Exercise[i+2]
            }
        }
        # Fill in break row info with following exercise
        br_rows = which(all_ex$Type == "Break")
        for(i in br_rows){
            all_ex$next_ex[i] <- all_ex$next_ex[i-1]
        }
        # Calculate start and stop of each exercise
        all_ex$sum = cumsum(all_ex$ex_time)
        all_ex$end = timer$total_length - all_ex$sum
        all_ex$start = all_ex$end + all_ex$ex_time

        all_ex
    })

    # Extract current exercise
    current_exercise <- reactive({
        full_ex_list()[which(full_ex_list()$start >= timer$time_remaining &
                                 full_ex_list()$end < timer$time_remaining),]

    })

    # Alter timer for current exercise
    observe({
        ex_timings = full_ex_list()$ex_time
        times = c()
        for(i in 1:length(ex_timings)){
            times <- c(times, seq(from = (ex_timings[i]-1), to = 0, by = -1))
        }
        timer$ex_countdown_seq = times
    })
    observe({
        invalidateLater(1000, session)
        isolate({
            # If timer is active, reduce all times by 1
            if(timer$timer_active == TRUE){
                # Calculate new total time remaining
                timer$current_ex_time = timer$ex_countdown_seq[timer$ex_seq_n]
                timer$ex_seq_n <- timer$ex_seq_n + 1
            }
        })
    })

    # Create text output for workout page
    output$current_ex_timer <- renderUI({
        HTML(paste0("<span style='font-size: 150px'>", timer$current_ex_time, "</span><br><br>",
                    "<span style='font-size: 40px'>", current_exercise()$Exercise, "</span><br><br>",
                    "<span style='font-size: 26px'>", current_exercise()$Description, "</span><br><br><br><br>"))
    })
    output$next_exercise  <- reactive({
        HTML(paste0("<span style='font-size: 30px'>Up next:</span><br>",
                    "<span style='font-size: 22px'>", current_exercise()$next_ex, "</span><br><br>"))
    })

    # Create table output for exercise list
    output$all_exercises <- renderTable({
        dplyr::select(full_ex_list(), Type, Exercise, Description) %>%
            filter(Type != "Break")
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
