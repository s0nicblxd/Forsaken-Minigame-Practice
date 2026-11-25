-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

return {
	LayoutOrder = 95,
	RequiredRank = "HeadModerator",
	Executable = false,
	Parameters = {},
	Title = "Friendly Fire (Always On)",
	ResetOnExecution = false,
	DisplayedAttribute = "FriendlyFire",
	AllowedInVIP = true,
    Executed = function(_, _) --[[ Line: 9 ]] --[[ Name: Executed ]]
        local l_workspace_Attribute_0 = workspace:GetAttribute("FriendlyFire");
        workspace:SetAttribute("FriendlyFire", true);
	end,
};