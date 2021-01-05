shinyServer(function(input, output) {

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
        WU_rv$exercises <- paste0("<span style='font-size: 16px'><i><br>", paste0(warmup$Exercise, collapse = "<br>"), "<br></i></span>")
    })

    # If length of warm-up is set to 0, reset exercise list
    # observeEvent(input$warmup_length == 0, {
    #     WU_rv$exercises <- ""
    # })

    # If user clicks button, reselect warm-up exercises
    observeEvent(input$warmup_go, {
        warmup <- set_exercises(n_ex = as.numeric(input$warmup_number), warmup = TRUE, type = NULL)
        WU_rv$exercises <- paste0("<span style='font-size: 16px'><i><br>", paste0(warmup$Exercise, collapse = "<br>"), "<br></i></span>")
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
})
