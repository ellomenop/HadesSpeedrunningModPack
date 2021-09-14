function HSMConfigMenu.CreateAttributionMenu(screen)
  local rowStartX = 250
  local columnSpacingX = 600
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 500
  local itemSpacingY = 65
  local itemsPerRow = 3

  -- Modded Game message customization
  screen.Components["ThanksForAllTheFish"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = ScreenCenterX - ScreenWidth * .4,
    Y = itemLocationY - 35,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["ThanksForAllTheFish"].Id,
    Text = "Modders: \\n"
      .. "Ellomenop, Museus, cgull, paradigmsort, erumi321, Magic_Gonads, PonyWarrior"
      .. "\\n Testers: The Entire Hades Speedrunning Commumity <3"
      .. " \\n\\n\\n Note from Ello: I just wanted to say thank you.\\n \\n Thank you to the Speedrunning Community:"
      .. " \\n This community is an immensely positive place to be and thats no accident."
      .. " \\n Its due to our shared love of this game (or perhaps our shared hatred of 5 sacks)."
      .. " \\n Its due to the hard work of everyone building each other up (even if its just so the Fish Flex hits that much harder)."
      .. " \\n Its due to being actively inclusive (even of those who love Merciful End or are getting a bit geriatric or even cant stop talking about that one time they were the first to beat Fresh File Hell Mode)."
      .. " \\n This community has meant a lot to me this past year, so thank you"
      .. " \\n \\n Thank you to the Modding Community:\\n"
      .. " Y'all are rad.  This modpack is only possible via the hard efforts of:\\n --  erumi321, Magic_Gonads, Museus, paradigmsort and PonyWarrior  --"
      .. " \\n Its been really fun and interesting to experience this game in a uniquely nerdy way with all of you."

      .. " \\n \\n Thank you Museus, Vorime, Wriste13, Duunk0, Bablo, SatanIsAChillGuy, and Haelian for the feedback (and friendship!)"
      .. " \\n I hope to repay you by forwarding all community complaints about the features of this modpack your way"
      .. " \\n \\n Lastly, thanks Amir for giving us R O D"
      .. " \\n \\n - Ello (ellomenop#2254)",
    Color = Color.LightGray,
    FontSize = 14,
    OffsetX = 0, OffsetY = 0,
    Width = ScreenWidth * .8,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
    VerticalJustification = "Top"
  })
end


ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "Credits / Notes"}, HSMConfigMenu.CreateAttributionMenu)
end)
