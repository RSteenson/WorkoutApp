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

            #----- Setup workout -----------------------------------------------

            #----- Setup cool-down ---------------------------------------------

        )
    )
)
