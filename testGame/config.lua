application =
{

	content =
	{
		width = 400,
		height = 600, 
		scale = "letterBox",
		fps = 60,
		
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
	},

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
