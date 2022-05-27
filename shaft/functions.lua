
local S = power_generators.translator

-- moment and revolution
-- I -> moment of inertia
-- T -> torque
-- rpm -> revolution
-- fric -> friction torque

function power_generators.shaft_step(self, pos, meta, use_usage)
  -- E = sum(I*rpm*rpm)
  -- E = I*rpm^2+I1*rpm1^2+I2*rmp2^2+I3*rmp3^2
  
  -- rpm1 = rpm*ratio1
  -- E = I*rpm^2+I1*rpm^2*ratio1^2+I2*rpm^2*ratio2^2+I3*rpm^2*ratio3^2
  -- rpm^2 = E/(I+I1*ratio1^2+I2*ratio2^2+I3*ratio3^2)
  
  -- L = sum(I*rpm)
  -- L = I*rpm+I1*rpm1+I2*rmp2+I3*rmp3
  -- L = I*rpm+I1*rpm*ratio1+I2*rpm*ratio2+I3*rpm*ratio3
  -- rpm = L/(I+I1*ratio1+I2*ratio2+I3*ratio3)
  
  local Isum = meta:get_int("Isum")
  local L = meta:get_int("L")
  local rpm = L/Isum
  local need_update = meta:get_int("update")
  if (rpm==0) and (need_update==0) then
    --local node = minetest.get_node(pos)
    --print("rpm 0 Isum: "..Isum.." L: "..L.." node: "..node.name)
    if self._rpm_deactivate then
      self:deactivate(pos, meta)
    end
    return
  end
  
  local shafts = {}
  
  local node = minetest.get_node(pos)
  local I = meta:get_int("I")
  local minT = 0
  
  Isum = I
  local Fsum = 0
  --local Tpwr = 0
  local rpmPwr = 0
  local rpmPwrSum = 0
  
  local powered_shafts = 0
  
  for _,side in pairs(self._shaft_sides) do
    local side_pos = appliances.get_side_pos(pos, node, side)
    local side_node = minetest.get_node(side_pos)
    local from_pos = pos
    local ratio = meta:get_float(side.."_ratio")
    local TPart = meta:get_float(side.."_Tpart")
    local s_I = 0
    local s_F = 0
    --print("side "..side.." node: "..dump(side_node))
    while ratio>0 do
      local shaft = minetest.get_item_group(side_node.name, "shaft")
      if shaft<=0 then
        break
      end
      local side_def = minetest.registered_nodes[side_node.name]
      local side_side = appliances.is_connected_to(side_pos, side_node, from_pos, side_def._shaft_sides)
      if not side_side then
        break
      end
      local side_meta = minetest.get_meta(side_pos)
      if shaft==1 then
        local o_ratio = side_meta:get_float(side_side.."_ratio")
        if o_ratio==0 then
          break
        end
        local o_I = side_meta:get_int("Isum")
        local o_F = side_meta:get_int("fric")
        --local o_T = side_meta:get_int("T")
        local o_rpm = side_meta:get_int("L")/o_I
        ratio = ratio/o_ratio
        local engine_side = meta:get_int(side.."_engine")
        local engine_side_side = side_meta:get_int(side_side.."_engine")
        
        table.insert(shafts, {
          meta = side_meta,
          timer = minetest.get_node_timer(side_pos),
          ratio = ratio,
          I = o_I,
          rpm = o_rpm,
          engine_side = engine_side,
          engine_side_side = engine_side_side,
          side = side,
          side_side = side_side,
          
          --[ [
          name = side_node.name,
          fric = o_F,
          side_TPart = TPart,
          --]]
        })
        if engine_side_side==0 then
          --print(string.format("Usum + s_I + o_I*ratio = %d + %d +%d*%f", Isum, s_I, o_I, ratio))
          Isum = Isum + s_I + o_I*ratio
          minT = minT + side_meta:get_int("minT")*ratio*TPart
          Fsum = Fsum + s_F + o_F*ratio*TPart
          powered_shafts = powered_shafts + 1
        else
          --Tpwr = Tpwr + o_T*ratio
          if rpmPwr>0 then
            rpmPwr = math.min(rpmPwr, o_rpm/ratio)
          else
            rpmPwr = o_rpm/ratio
          end
          rpmPwrSum = rpmPwrSum + o_rpm/ratio
        end
        break
      else
        s_I = s_I + side_meta:get_int("I")*ratio
        s_F = s_F + side_meta:get_float("fric")*ratio
      end
      
      from_pos = side_pos
      side_pos = appliances.get_side_pos(side_pos, side_node, appliances.opposite_side[side_side])
      side_node = minetest.get_node(side_pos)
    end
    -- special update code
    while (ratio==0) and (need_update==1) do
      local shaft = minetest.get_item_group(side_node.name, "shaft")
      if shaft<=0 then
        break
      end
      local side_def = minetest.registered_nodes[side_node.name]
      local side_side = appliances.is_connected_to(side_pos, side_node, from_pos, side_def._shaft_sides)
      if not side_side then
        break
      end
      local side_meta = minetest.get_meta(side_pos)
      if shaft==1 then
        local o_ratio = side_meta:get_float(side_side.."_ratio")
        if o_ratio==0 then
          break
        end
        local engine_side_side = side_meta:get_int(side_side.."_engine")
        -- enable update
        if engine_side_side~=0 then
          side_meta:set_int("update", 1)
          local timer = minetest.get_node_timer(side_pos)
          if not timer:is_started() then
            timer:start(1)
          end
          --print("Apply update for ratio 0 side "..side_node.name)
        end
        break
      end
    end
  end
  
  -- losts
  --print(node.name.." on "..minetest.pos_to_string(pos))
  local friction = self._friction + Fsum
  if not friction then
    friction = meta:get_float("fric")
  end
  if use_usage then
    friction = friction*use_usage.friction
  end
  local qgrease = meta:get_float("qgrease")
  local agrease = meta:get_float("agrease")
  if agrease>0 then
    friction = friction*qgrease
    agrease = agrease - (rpm*friction*0.0000001) -- about 10000 s at 1000 rpm friction 1 and 1 amount
    meta:set_float("agrease", math.max(agrease, 0))
    qgrease = self._qgrease_max - self._qgrease_eff*qgrease
  else
    qgrease = self._qgrease_max
  end
  -- min on 480 rpm 1300 friction, at 0 rpm 2000 friction
  friction = friction*(qgrease*rpm+2000000/(3*rpm+1000))
  minT = minT + friction
  --E = math.max(E - friction*(rpm+1000), 0)
  --print("rpmPwr: "..rpmPwr.." Isum: "..Isum.." friction: "..friction.." minT: "..minT)
  --print("shafts: "..dump(shafts))
  
  -- recalculate
  if rpmPwr>0 then
    rpm = rpmPwr
  else
    rpm = math.max(rpm - minT/Isum, 0)
  end
  local new_rpm
  for _,shaft in pairs(shafts) do
    new_rpm = rpm*shaft.ratio
    shaft.meta:set_int("L", math.floor(new_rpm*shaft.I))
    if (shaft.engine_side_side==0) and (rpmPwr>0) then
      meta:set_int(shaft.side.."_engine", 1)
      --print("meta "..node.name.." "..shaft.side.."_engine: 1")
    elseif (shaft.engine_side~=2) and (rpmPwr==0) then
      --meta:set_int(shaft.side.."_engine", 0)
      --meta:set_int("Tsum", 0)
      --print("meta "..node.name.." "..shaft.side.."_engine: 0")
    elseif (shaft.engine_side_side~=0) then
      if shaft.engine_side==0 then
        shaft.meta:set_float(shaft.side_side.."_Tpart", shaft.rpm/shaft.ratio/rpmPwrSum)
        --print("Tpart: "..(shaft.rpm/shaft.ratio/rpmPwrSum))
        --print("rpmPwrSum: "..rpmPwrSum)
      --else
        --shaft.meta:set_float(shaft.side_side.."_engine", 0)
      end
    end
    if new_rpm>0 then
      if (not shaft.timer:is_started()) then
        shaft.timer:start(1)
      end
    elseif (need_update==1) and (shaft.engine_side_side~=0) then
      if (not shaft.timer:is_started()) then
        shaft.timer:start(1)
      end
      shaft.meta:set_int("update", 1)
      --print(dump(shaft))
    end
    --print("rpm: "..new_rpm)
    --[[
    if shaft.engine_side_side~=0 then
      print(node.name.." on "..minetest.pos_to_string(pos).." powered from side "..shaft.side.." via "..shaft.name)
    end
    --]]
  end
  meta:set_int("L", math.floor(rpm*Isum))
  
  meta:set_int("minT", math.ceil(minT))
  meta:set_int("Isum", math.ceil(Isum))
  --print("rpm: "..rpm)
  
  if (need_update==1) then
    meta:set_int("update", 0)
  end
  
  if (#shafts==1) and (powered_shafts == 1) then
    local shaft = shafts[1]
    --print("Check reset: "..dump(shaft))
    if (shaft.engine_side==1) then
      -- not if engine_side is 2
      meta:set_int(shaft.side.."_engine", 0)
      shaft.meta:set_int(shaft.side_side.."_engine", 0)
      --print("Reset engine side "..shaft.name)
    end
  elseif (#shafts==2) and (powered_shafts == 0) and (rpmPwr>0) then
    local shaft1 = shafts[1]
    local shaft2 = shafts[2]
    if shaft1.rpm > shaft2.rpm then
      --print("Update engine side "..shaft1.name.." to "..shaft2.name)
      meta:set_int(shaft1.side.."_engine", 0)
      shaft1.meta:set_int(shaft1.side_side.."_engine", 1)
      meta:set_int(shaft2.side.."_engine", 1)
      shaft2.meta:set_int(shaft2.side_side.."_engine", 0)
    else
      --print("Update engine side "..shaft2.name.." to "..shaft1.name)
      meta:set_int(shaft1.side.."_engine", 1)
      shaft1.meta:set_int(shaft1.side_side.."_engine", 0)
      meta:set_int(shaft2.side.."_engine", 0)
      shaft2.meta:set_int(shaft2.side_side.."_engine", 1)
    end
  elseif (#shafts>2) and (powered_shafts==#shafts) then
    --print("Reset engine sides "..node.name)
    for _, shaft in pairs(shafts) do
      meta:set_int(shaft.side.."_engine", 0)
      shaft.meta:set_int(shaft.side_side.."_engine", 0)
    end
  end
end

function power_generators.update_shaft_supply(self, pos, meta, speed)
  local I = meta:get_int("Isum")
  local rpm = meta:get_int("L")/I
  
  local T = self:get_torque(pos, meta, rpm, I, speed)
  
  rpm = math.max(rpm + T/I, 0)
  -- minT is used in step function
  --print("T: "..T.." I: "..I.." rpm: "..rpm)
  
  meta:set_int("L", math.ceil(rpm*I))
  if rpm>0 then
    for _,side in pairs(self._shaft_sides) do
      meta:set_int(side.."_engine", 2)
      --print("meta "..side.."_engine: 2")
    end
  end
end

--function power_generators.ee_get_torque(self, pos, meta, rpm, I, speed)
function power_generators.ee_get_torque(self, _, _, rpm, _, speed)
  local T = self._maxT
  local maxP = self._maxP*speed
  if rpm>self._limitRpm then
    maxP = maxP*(self._limitRpm/rpm)^2
  end
  local P = T*rpm
  if P>maxP then
    T = maxP/rpm
  end
  return T
end

function power_generators.apply_grease(itemstack, user, pointed_thing)
  if pointed_thing.type=="node" then
    local pos = pointed_thing.under
    local node = minetest.get_node(pos)
    if minetest.get_item_group(node.name, "greasable")>0 then
      local meta = minetest.get_meta(pos)
      local idef = itemstack:get_definition()
      local agrease = meta:get_float("agrease")
      if agrease<idef._agrease then
        local qgrease = meta:get_float("qgrease")
        
        qgrease = qgrease*agrease + idef._qgrease*idef._agrease
        agrease = agrease + idef._agrease
        
        meta:set_float("agrease", agrease)
        meta:set_float("qgrease", qgrease/agrease)
        
        meta:set_int("update", 1)
        local timer = minetest.get_node_timer(pos)
        if not timer:is_started() then
          timer:start(1)
        end
        
        itemstack:take_item()
        
        if idef._grease_empty then
          local inv = user:get_inventory()
          local notadd = inv:add_item("main", ItemStack(idef._grease_empty))
          if notadd:get_count()>0 then
            minetest.add_item(user:get_pos(), notadd)
          end
        end
        
        return itemstack
      end
      
    end
    return minetest.node_punch(pos, node, user, pointed_thing)
  end
end

function power_generators.grease_inspect_msg(data, level)
  if type(data)=="table" then
    local meta = minetest.get_meta(data)
    local agrease = meta:get_float("agrease")
    local qgrease = meta:get_float("qgrease")
    local acoef = 0.2
    local qcoef = 0.1
    if level==2 then
      acoef = 0.1
      qcoef = 0.05
    elseif level==3 then
      acoef = 0.05
      qcoef = 0.01
    end
    local aval = math.round(agrease/acoef)*acoef
    local aop = "< "
    if aval<agrease then
      aop = "> "
    end
    local qval = math.round(qgrease/qcoef)*qcoef
    local msg = S("Discovered level of grease amount is @1.", aop..aval)
    if level>1 then
      msg = msg .. "\n" .. S("Discovered quality of grease is @1.", qval)
    end
    return msg
  else
    local def = data:get_definition()
    if not def._agrease then
      return def.description
    end
    local agrease = def._agrease
    local qgrease = def._qgrease
    local acoef = 0.4
    local qcoef = 0.2
    if level==2 then
      acoef = 0.2
      qcoef = 0.1
    elseif level==3 then
      acoef = 0.1
      qcoef = 0.05
    end
    local aval = math.round(agrease/acoef)*acoef
    local aop = "< "
    if aval<agrease then
      aop = "> "
    end
    local qval = math.round(qgrease/qcoef)*qcoef
    local msg = S("Discover level of inventory grease amount is @1.", aop..aval)
    if level>1 then
      msg = msg .. "\n" .. S("Discovered quality of inventory grease is @1.", qval)
    end
    return msg
  end
end

function power_generators.rpm_can_dig(self, pos, player)
  local meta = minetest.get_meta(pos)
  if meta:get_int("L")>0 then
    if player then
      local player_name = player:get_player_name()
      if player_name~="" then
        minetest.chat_send_player(player_name, S("It is rotating! Can't be digged!"))
      end
    end
    return false
  end
  return self:cb_can_dig_orig(pos, player)
end

function power_generators.set_rpm_can_dig(self)
  self.cb_can_dig_orig = self.cb_can_dig
  self.cb_can_dig = power_generators.rpm_can_dig
end

