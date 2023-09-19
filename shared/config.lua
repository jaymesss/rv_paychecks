Config = {}
Config.CoreName = "qb-core"
Config.PayCheckInterval = 15 -- In Minutes
Config.Locations = {
    {
        name = "Life Invader",
        blip = {
            coords = vector3(-1080.73, -251.91, 44.02),
            sprite = 590,
            scale = 0.65,
            color = 3,
        },
        ped = {
            coords = vector4(-1083.22, -245.78, 36.76, 207.04),
            model = 'a_f_y_business_04'
        },
        target = {
            coords = vector3(-1083.22, -245.78, 36.76),
            heading = 240,
            label = "Open Life Invader"
        }
    }
}
Config.Messages = {
    collected = 'You collected $amount in paychecks!',
    noneAvailable = 'You have no paychecks available.',
    paycheckAvailable = 'You have $amount available at LifeInvader!'
}
Config.Menu = {
    title = 'Welcome! You have $amount waiting!',
    collect = 'Collect Paycheck',
    description = 'Get your paycheck paid in cash!',
    icon = 'dollar'
}
