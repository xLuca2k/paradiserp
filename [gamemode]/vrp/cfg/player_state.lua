local cfg = {}

cfg.spawn_enabled = true
cfg.spawn_position = {150.90187072754,-679.77416992188,42.029479980469}
cfg.spawn_death = {-805.02044677734,-1237.7546386719,7.3374223709106}
cfg.spawn_radius = 1
cfg.default_customization = {model = "mp_m_freemode_01"}
for i=0,19 do
  cfg.default_customization[i] = {0,0}
end
cfg.clear_phone_directory_on_death = false
cfg.lose_aptitudes_on_death = false

return cfg