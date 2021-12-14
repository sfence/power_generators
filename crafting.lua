
local items = {
  strong_ingot = "default:steel_ingot",
  metal_ingot = "default:steel_ingot",
  copper_ingot = "default:copper_ingot",
  mese_fragment = "default:mese_crystal_fragment",
  metal_block = "default:steelblock",
  
  copper_wire = "basic_materials:copper_wire",
  empty_spool = "basic_materials:empty_spool",
  controller = "basic_materials:ic",
  
  gear = "basic_materials:gear_steel",
  electric_motor = "basic_materials:motor",
  transforemr = "basic_materials:gold_wire",
  
  bar = "basic_materials:steel_bar",
  
  dye_yellow = "dye:yellow",
}

if minetest.get_modpath("hades_core") then
  items.strong_ingot = "hades_core:steel_ingot"
  items.metal_ingot = "hades_core:steel_ingot"
  items.copper_ingot = "hades_core:copper_ingot"
  items.mese_fragment = "hades_core:mese_crystal_fragment"
  items.metal_block = "hades_core:steelblock"
  
  items.copper_wire = "hades_extramaterials:copper_wire"
  items.empty_spool = "hades_extramaterials:empty_spool"
  items.controller = "hades_extramaterials:ic"
  
  items.gear = "hades_extramaterials:gear_steel"
  items.electric_motor = "hades_extramaterials:motor"
  items.transformer = "hades_extramaterials:gold_wire"
  
  items.bar = "hades_extramaterials:steel_bar"
end

if minetest.get_modpath("technic") then
  items.strong_ingot = "technic:stainless_steel_ingot"
  items.metal_ingot = "technic:carbon_steel_ingot"
  items.metal_block = "technic:carbon_steel_ingot"
  items.controller = "technic:control_logic_unit"
  
  items.transformer = "technic:lv_transformer"
end

if minetest.get_modpath("hades_technic") then
  items.strong_ingot = "hades_technic:stainless_steel_ingot"
  items.metal_ingot = "hades_technic:carbon_steel_ingot"
  items.metal_block = "hades_technic:carbon_steel_ingot"
  items.controller = "hades_technic:control_logic_unit"
  
  items.transformer = "hades_technic:lv_transformer"
end

minetest.register_craft({
    output = "power_generators:electric_cableS 6",
    recipe = {
      {"basic_materials:plastic_sheet", items.dye_yellow, ""},
      {"", "basic_materials:copper_wire", ""},
      {"", "", "basic_materials:plastic_sheet"},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:junction_box",
    recipe = {
      {"power_generators:electric_cableS", "power_generators:electric_cableS", "power_generators:electric_cableS"},
      {"basic_materials:plastic_sheet", items.metal_block, "basic_materials:plastic_sheet"},
      {items.transformer, items.transformer, items.transformer},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_piston",
    recipe = {
      {items.strong_ingot, items.strong_ingot, items.strong_ingot},
      {"", items.strong_ingot, ""},
      {"", items.strong_ingot, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_cylinder_body",
    recipe = {
      {items.strong_ingot, "", items.strong_ingot},
      {items.strong_ingot, "", items.strong_ingot},
      {items.strong_ingot, items.strong_ingot, items.strong_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_crankshaft 2",
    recipe = {
      {"", items.strong_ingot, items.strong_ingot},
      {"", items.strong_ingot, ""},
      {items.strong_ingot, items.strong_ingot, ""},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_spark_plug",
    recipe = {
      {items.copper_ingot, items.copper_wire, items.copper_ingot},
      {"", items.mese_fragment, ""},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", items.metal_ingot, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", "", "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_2_controlled",
    recipe = {
      {"power_generators:combustion_engine_spark_plug", items.metal_ingot, "power_generators:combustion_engine_spark_plug"},
      {"power_generators:combustion_engine_piston", items.controller, "power_generators:combustion_engine_piston"},
      {"power_generators:combustion_engine_cylinder_body", "power_generators:combustion_engine_crankshaft", "power_generators:combustion_engine_cylinder_body"},
    }
  })

--[[
minetest.register_craft({
    output = "power_generators:combustion_engine_body_4",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_body_6",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {"power_generators:combustion_engine_body_2","power_generators:combustion_engine_body_2", "power_generators:combustion_engine_body_2"},
      {"power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft","power_generators:combustion_engine_crankshaft"},
    }
  })
--]]

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders",
    recipe = {
      {items.metal_ingot, "", items.metal_ingot},
      {items.copper_wire, "power_generators:combustion_engine_body_2", items.copper_wire},
      {items.metal_ingot, items.bar, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_two_cylinders_controlled",
    recipe = {
      {items.metal_ingot, items.controller, items.metal_ingot},
      {items.copper_wire, "power_generators:combustion_engine_body_2_controlled", items.copper_wire},
      {items.metal_ingot, items.bar, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_gearbox",
    recipe = {
      {items.metal_ingot, items.gear, items.metal_ingot},
      {items.metal_ingot, items.gear, items.metal_ingot},
      {items.metal_ingot, items.gear, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_alternator",
    recipe = {
      {"", items.transformer, ""},
      {"", items.electric_motor, ""},
      {items.metal_ingot, "", items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:combustion_engine_fuel_tank",
    recipe = {
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
      {items.metal_ingot, "", items.metal_ingot},
      {items.metal_ingot, items.metal_ingot, items.metal_ingot},
    }
  })

minetest.register_craft({
    output = "power_generators:emergency_generator",
    recipe = {
      {items.metal_ingot, "power_generators:combustion_engine_fuel_tank", items.metal_ingot},
      {"power_generators:combustion_engine_two_cylinders", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {items.metal_ingot, "", items.metal_ingot},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })

minetest.register_craft({
    output = "power_generators:emergency_generator_2",
    recipe = {
      {items.metal_ingot, "power_generators:combustion_engine_fuel_tank", items.metal_ingot},
      {"power_generators:combustion_engine_two_cylinders_controlled", "power_generators:combustion_engine_gearbox", "power_generators:combustion_engine_alternator"},
      {items.metal_ingot, "", items.metal_ingot},
    },
    replacements = {{items.copper_wire,items.empty_spool}},
  })
