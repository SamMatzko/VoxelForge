-- Backwards compat code for "old" 0.83 and prior pigman. This transforms all
-- existing pigmen into the new zombified piglins.

local pigman = {
	textures = {{ "" }},
	after_activate = function(self)
		self.object = mcl_util.replace_mob(self.object, "mobs_mc:zombified_piglin")
	end,
}

mcl_mobs.register_mob("mobs_mc:pigman", pigman)
mcl_mobs.register_mob("mobs_mc:baby_pigman", pigman)
