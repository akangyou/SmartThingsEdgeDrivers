local cluster_base = require "st.matter.cluster_base"
local data_types = require "st.matter.data_types"
local TLVParser = require "st.matter.TLV.TLVParser"

local ActuatorEnabled = {
  ID = 0x0002,
  NAME = "ActuatorEnabled",
  base_type = require "st.matter.data_types.Boolean",
}

function ActuatorEnabled:new_value(...)
  local o = self.base_type(table.unpack({...}))

  return o
end

function ActuatorEnabled:read(device, endpoint_id)
  return cluster_base.read(
    device,
    endpoint_id,
    self._cluster.ID,
    self.ID,
    nil
  )
end

function ActuatorEnabled:subscribe(device, endpoint_id)
  return cluster_base.subscribe(
    device,
    endpoint_id,
    self._cluster.ID,
    self.ID,
    nil --event_id
  )
end

function ActuatorEnabled:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

function ActuatorEnabled:build_test_report_data(
  device,
  endpoint_id,
  value,
  status
)
  local data = data_types.validate_or_build_type(value, self.base_type)

  return cluster_base.build_test_report_data(
    device,
    endpoint_id,
    self._cluster.ID,
    self.ID,
    data,
    status
  )
end

function ActuatorEnabled:deserialize(tlv_buf)
  local data = TLVParser.decode_tlv(tlv_buf)

  return data
end

setmetatable(ActuatorEnabled, {__call = ActuatorEnabled.new_value, __index = ActuatorEnabled.base_type})
return ActuatorEnabled