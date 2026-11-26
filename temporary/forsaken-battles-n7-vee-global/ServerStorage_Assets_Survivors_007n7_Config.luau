local v0 = {
    DisplayName = "007n7", 
    Quote = "\"all your base are belong 2 me\"", 
    Credits = "", 
    Class = "Survivalist", 
    RenderImage = "rbxassetid://97831052846546", 
    Price = 500, 
    Speed = 12, 
    CloneCooldown = 27, 
    CloneAmount = 1, 
    CloneLifetime = 10,
    CursorCloneLifetime = 5, 
    CloneSpeed = 26, 
    CloneControlWindup = 0.1, 
    CloneAbilitiesDisabledTime = 3, 
    InvisibilityTime = 5, 
    SlownessTime = 10, 
    c00lguiCooldown = 50, 
    c00lguiWindupTime = 5.5, 
    c00lguiTemplate = script.c00lgui, 
    InjectCooldown = 0, 
    InjectTemplate = script.InjectUI, 
    DexTemplate = script.DexUI, 
    Expressions = {
        Happy = "rbxassetid://73681026143116", 
        Default = "rbxassetid://113636964019707", 
        Hurt = "rbxassetid://120964970637371", 
        Injured = "rbxassetid://90397620676516", 
        Dead = "rbxassetid://135205642944949", 
        Drinking = "rbxassetid://136500513030872", 
        Concentrating = "rbxassetid://92883468581918"
    }, 
    Animations = {
        c00lguiStart = "rbxassetid://71164389345759"
    }, 
    Sounds = {
        c00lguiActivated = "rbxassetid://88730833027112"
    }, 
    TextInteractions = {
        Requests = {
            ElliotPizza = {
                "I know you aren\226\128\153t too pleased to see me, I can tell. But can we put our differences aside for once?", 
                "You have all the right to deny me service, but I\226\128\153ll still ask for a pizza slice, if that\226\128\153s okay..", 
                "I hate to ask, but I really need something to keep me going..", 
                "My family hasn\226\128\153t been the best to you and your work, but I\226\128\153d be thankful for a slice of pizza..", 
                "Can I ask for something? It\226\128\153s okay if you refuse, I can understand.."
            }, 
            BuildermanSentry = {
                "A sentry here should be good..", 
                "One sentry over here would be a good spot, I think..", 
                "A sentry over here should work..", 
                "Can you put down a sentry over here?", 
                "Are you able to put a sentry down over this spot?"
            }, 
            BuildermanDispenser = {
                "Are you able to put down a dispenser over here?", 
                "I won\226\128\153t do anything funny. I just think a dispenser would be a good spot here..", 
                "Can you put a dispenser here?", 
                "A dispenser could be of use over in this spot..", 
                "Could you put a dispenser here? If that\226\128\153s okay."
            }, 
            DusekkarProtection = {
                "A little protection over here..!", 
                "Could I have some of your magic to protect me?", 
                "Your skill is useful, reminds me a lot of... nevermind. Can I have a little protection..?", 
                "Quick, use your magic..!", 
                "Could you use your spell to shield me from their attack?"
            }, 
            HemmorhageAsk = {
                "I.. I don't mean to be trouble, just... I'm bleeding.", 
                "I'm er.. bleeding, quite a bit... I need to ask for your help.", 
                "Please... I won't bother you with anything, just.. just something to help with this bleeding...", 
                "D-Don't misunderstand! I just... need help with this deep wound I got..", 
                "I'll be out of your hair..! I just.. need some quick help with this bleeding problem..."
            }
        }, 
        Thanks = {
            Regular = {
                "I... don\226\128\153t deserve this.. Thank you.", 
                "Thank you for trusting me..", 
                "Thank you very much.", 
                "I wasn\226\128\153t.. expecting this, thank you.", 
                "Thank you. I\226\128\153m glad you trust me.", 
                "Thank you so much. I\226\128\153ll try to pay it forward."
            }, 
            ElliotPizza = {
                {
                    "007n7: ...Uh.. T-Thank you...", 
                    "Elliot: ...", 
                    "Elliot: Just get going."
                }, 
                {
                    "007n7: Thank you.. a lot for this.", 
                    "Elliot: ...", 
                    "007n7: ..."
                }
            }
        }
    }
};
v0.Information = {
    {
        Separator = "GENERAL INFO"
    }, 
    {
        Header = "007N7", 
        Text = "Previously infamous for their exploits, he had a change of heart after gaining a son, only to then lose him after a series of unfortunate events. With a smaller copy of the c00lgui on him, he's able to teleport far in the map, as well as create a duplicate of himself if need be.\n"
    }, 
    {
        Header = "STATS", 
        Text = "Difficulty: \226\152\133\226\152\133\226\152\133\226\152\133\226\152\134\n" .. ("Health: %*\n"):format(v0.Health or 100) .. ("Regular Speed: %*\n"):format(v0.Speed or 12) .. ("Sprinting Speed: %*\n"):format(v0.SprintSpeed or 26) .. ("Max Stamina: %*\n"):format(v0.MaxStamina or 100) .. ("Stamina Loss per sec: %*\n"):format(v0.StaminaLoss or 10) .. ("Stamina Gain per sec: %*\n"):format(v0.StaminaGain or 20)
    }, 
    {
        Separator = "PASSIVES"
    }, 
    {
        Image = nil, 
        Header = "DEX", 
        Quote = "\"get saveinstance()'d skrub\" - loser #4854", 
        Text = "007n7 will always be able to see the location of the furthest survivor spawn from him.\n"
    }, 
    {
        Separator = "ABILITIES"
    }, 
    {
        Image = "rbxassetid://83534637834767", 
        Header = "CLONE", 
        Quote = "\"YOUTUBE THIS IS NOT FUN\" - victim", 
        Text = ("Cooldown: %*s\n"):format(v0.CloneCooldown) .. ("When activated, 007n7 taps into his exploits to create a clone of himself that lives for %*s before dying.\n"):format(v0.CloneLifetime) .. ("Upon creating a clone, 007n7 is given <b>Invisibility IV</b> and <b>Undetectable I</b> for %*s.\n"):format(v0.InvisibilityTime) .. "The clone, by default, will wander aimlessly, but this can be changed through using the <b>Inject</b> ability (see below).\n"
    }, 
    {
        Image = "rbxassetid://89910721511648", 
        Header = "C00LGUI", 
        Quote = "\"where's my house\" - victim", 
        Text = ("Cooldown: %*s\n"):format(v0.c00lguiCooldown) .. ("007n7 stands in place for %*s before teleporting away to the furthest survivor spawn location from him.\n"):format(v0.c00lguiWindupTime) .. "Being hit during this ability cancels it immediately.\n"
    }, 
    {
        Image = "rbxassetid://85844834952266", 
        Header = "INJECT", 
        Quote = "\"dude stop hacking kid\" - victim", 
        Text = ("Cooldown: %*s\n"):format(v0.InjectCooldown) .. "Upon activation, the clones created using 007n7's Clone ability will have their movement type switched.\n" .. "1. Aimless Wandering\n" .. "\tThe clone wanders around randomly & aimlessly\n" .. "2. Pathfinding\n" .. "\tThe clone pathfinds to the furthest survivor spawn\n" .. "3. Cursor\n" .. "\tThe clone moves towards the player's cursor\n"
    }
};
return v0;