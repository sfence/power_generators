
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
  if rpm==0 then
    --local node = minetest.get_node(pos)
    --print("rpm 0 Isum: "..Isum.." L: "..L.." node: "..node.name)
    return
  end
  
  local shafts = {}
  
  local node = minetest.get_node(pos)
  local I = meta:get_int("I")
  local minT = 0
  
  local Isum = I
  --local Tpwr = 0
  local rpmPwr = 0
  local rpmPwrSum = 0
  
  for _,side in pairs(self._shaft_sides) do
    local side_pos = appliances.get_side_pos(pos, node, side)
    local side_node = minetest.get_node(side_pos)
    local from_pos = pos
    local ratio = meta:get_float(side.."_ratio")
    local TPart = meta:get_float(side.."_Tpart")
    local s_I = 0
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
        --local o_T = side_meta:get_int("T")
        local o_rpm = side_meta:get_int("L")/o_I
        ratio = ratio/o_ratio
        local engine_side = meta:get_int(side.."_engine")
        local engine_side_side = side_meta:get_int(side_side.."_engine")
        
        table.insert(shafts, {
          meta = side_meta,
          ratio = ratio,
          I = o_I,
          --T = o_T,
          rpm = o_rpm,
          engine_side = engine_side,
          engine_side_side = engine_side_side,
          side = side,
          side_side = side_side,
          side_TPart = TPart,
          name = side_node.name,
        })
        if engine_side_side==0 then
          --print(string.format("Usum + s_I + o_I*ratio = %d + %d +%d*%f", Isum, s_I, o_I, ratio))
          Isum = Isum + s_I + o_I*ratio
          minT = minT + side_meta:get_int("minT")*ratio*TPart
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
      end
      
      from_pos = side_pos
      side_pos = appliances.get_side_pos(side_pos, side_node, appliances.opposite_side[side_side])
      side_node = minetest.get_node(side_pos)
    end
  end
  
  -- losts
  local friction = self._friction
  if not friction then
    friction = meta:get_float("friction")
  end
  if use_usage then
    friction = friction*use_usage.friction
  end
  local qgrease = meta:get_float("qgrease")
  local agrease = meta:get_float("agrease")
  if agrease>0 then
    friction = friction*qgrease
    agrease = agrease - (rpm*friction*0.000001) -- about 1000 s at 1000 rpm friction 1 and 1 amount
    meta:set_float("agrease", math.max(agrease, 0))
  else
    qgrease = 1
  end
  -- min on 480 rpm 1300 friction, at 0 rpm 2000 friction
  friction = friction*(rpm+qgrease*2000000/(3*rpm+1000))
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
      meta:set_int(shaft.side.."_engine", 0)
      meta:set_int("Tsum", 0)
      --print("meta "..node.name.." "..shaft.side.."_engine: 0")
    elseif (shaft.engine_side_side~=0) then
      shaft.meta:set_float(shaft.side_side.."_Tpart", shaft.rpm/shaft.ratio/rpmPwrSum)
      --print("Tpart: "..(shaft.rpm/shaft.ratio/rpmPwrSum))
    end
    --print("rpm: "..new_rpm)
  end
  meta:set_int("L", math.floor(rpm*Isum))
  
  if rpm>0 then
    meta:set_int("minT", math.ceil(minT))
    meta:set_int("Isum", math.ceil(Isum))
  else
    meta:set_int("minT", math.ceil(friction))
    meta:set_int("Isum", math.ceil(I))
  end
  --print("rpm: "..rpm)
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

function power_generators.ee_get_torque(self, pos, meta, rpm, I, speed)
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

