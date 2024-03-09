
local cfg = {}

cfg.item_transformers = {
  {
    name="Pescuit",
    permissions = {"mission.delivery.fish"},
    r=0,g=125,b=255,
    max_units=100,
    units_per_minute=10,
    x=743.19586181641,y=3895.3967285156,z=30.5, 
    radius=50, height=1.5,
    recipes = {
      ["Prinde niste Somon"] = {
        description="Incercand sa prind Somon cu undita",
        in_money=0,
        out_money=0,
        reagents={},
        products={
          ["catfish"] = 1
        }
      },
      ["Prinde niste Caras"] = {
        description="Incercand sa prind Caras cu undita",
        in_money=0,
        out_money=0,
        reagents={},
        products={
          ["bass"] = 1
        }
      }
    }
  },
  {
    name="Organe de Furat", -- menu name
    permissions = {"mission.organe"}, -- you can add permissions
    r=0,g=125,b=255, -- color
    max_units=50,
    units_per_minute=10,
    x=-2166.6140136719,y=5197.3666992188,z=16.880374908447,
    radius=3, height=1.5, -- area
    recipes = {
      ["Fura Inima si Rinichi"] = { -- action name
        description="Fura niste inimi si niste rinichi pentru a le vinde pe Deep Web", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["rinichi"] = 1,
          ["inima"] = 1
        }
      },
      ["Fura Ficati"] = { -- action name
        description="Fura niste ficati pentru a le vinde pe Deep Web", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["ficat"] = 1
        }
      }
    }
  },
  {
    name="Braconieri din Africa", -- menu name
    permissions = {"mission.poacher.partbodies"}, -- you can add permissions
    r=0,g=125,b=255, -- color
    max_units=50,
    units_per_minute=10,
    x=-125.58402252197,y=1895.6229248047,z=197.3328704834,
    radius=3, height=1.5, -- area
    recipes = {
      ["Pachete din Africa"] = { -- action name
        description="Ia pachete de la Braconeiri Africani", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["horn"] = 1,
		      ["ivory"] = 1
        }
      }
    }
  },
  {
    name="Braconieri din Asia", -- menu name
    permissions = {"mission.poachers.partbodies"}, -- you can add permissions
    r=0,g=125,b=255, -- color
    max_units=50,
    units_per_minute=10,
    x=3823.3518066406,y=4441.0244140625,z=2.8032081127167,
    radius=3, height=1.5, -- area
    recipes = {
      ["Pachete din Asia"] = { -- action name
        description="Ia pachete de la Braconieri Asiatici", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["fur"] = 1,
		      ["furs"] = 1
        }
      }
    }
  },

 --[[ {
		name="Traficant de arme - Procuratura",
		permissions = {"procupra.piese.traficant"},
		r=0,g=125,b=255, -- color
		max_units = 1000,
		units_per_minute = 100,
		x = 2806.2141113281, y = 5978.4370117188, z = 350.7048034668,
		radius = 3, height = 1.0,
		recipes = {
			["SPECIAL_CARBINE_MK2"] = {
				description="Procupara piese pentru fabricarea unui SPECIAL_CARBINE_MK2",
				in_money = 0,
				out_money = 0,
				reagents = { },
				products = {
					["teava_carabine_mk2"] = 1,
					["mecanisc_carabine_mk2"] = 1,
					["inchizator_carabine_mk2"] = 1
				}
			},
			["SMG_MK2"] = {
				description="Procura piese pentru fabricarea unui SMG_MK2",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["teava_smg_mk2"] = 1,
					["mecanisc_smg_mk2"] = 1,
					["inchizator_smg_mk2"] = 1
				}
			},
			["PISTOL_MK2"] = {
				description = "Procura piese pentru fabricarea unui PISTOL_MK2",
				in_money = 0,
				out_money = 0,
				reagents={ },
				products = {
					["teava_pistol_mk2"] = 1,
					["mecanisc_pistol_mk2"] = 1,
					["inchizator_pistol_mk2"] = 1
				}
			}
		}
  },
  
  
  {
		name="Traficant de arme - Fabrica",
		permissions = {"procupra.piese.traficant"},
		r=0,g=125,b=255, -- color
		max_units = 500,
		units_per_minute = 25,
		x = 91.837455749512, y = 3754.595703125, z = 40.774894714355,
		radius = 3, height = 1.0,
		recipes = {
			["SPECIAL_CARBINE_MK2"] = {
				description="Fabrica un SPECIAL_CARBINE_MK2 cu piesele procurate.",
				in_money = 0,
				out_money = 0,
				reagents = { 
					["teava_carabine_mk2"] = 1,
					["mecanisc_carabine_mk2"] = 1,
					["inchizator_carabine_mk2"] = 1
				},
				products = {
					["wbody|WEAPON_SPECIALCARBINE_MK2"] = 1,
					["wammo|WEAPON_SPECIALCARBINE_MK2"] = 250,
				}
			},
			["SMG_MK2"] = {
				description="Fabrica un SMG_MK2 cu piesele procurate.",
				in_money=0,
				out_money=0,
				reagents={
					["teava_smg_mk2"] = 1,
					["mecanisc_smg_mk2"] = 1,
					["inchizator_smg_mk2"] = 1
				},
				products={
					["wbody|WEAPON_SMG_MK2"] = 1,
					["wammo|WEAPON_SMG_MK2"] = 250,
				}
			},
			["PISTOL_MK2"] = {
				description = "Fabrica un PISTOL_MK2 cu piesele procurate.",
				in_money = 0,
				out_money = 0,
				reagents={ 
					["teava_pistol_mk2"] = 1,
					["mecanisc_pistol_mk2"] = 1,
					["inchizator_pistol_mk2"] = 1
				},
				products = {
					["wbody|WEAPON_PISTOL_MK2"] = 1,
					["wammo|WEAPON_PISTOL_MK2"] = 250,
				}
			}
		}
  },]]
  {
    name="Falsificator", -- menu name
	  permissions = {"fraud.credit_cards"}, -- you can add permissions
    r=255,g=125,b=0, -- color
    max_units=100000,
    units_per_minute=100000,
    x=1272.7305908203,y=-1711.9899902344,z=54.771453857422,
    radius=2, height=1.0, -- area
    recipes = {
      ["Falsificand Card-uri de Credit Furate"] = { -- action name
        description="Falsificand card-uri de credit furate in Buletine Ilegale", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={
		      ["credit"] = 1
		    }, -- items taken per unit
        products={
		      ["fake_id"] = 1
		    }, -- items given per unit
        aptitudes={}
      }
    }
  },
  {
    name="Droguri", -- menu name
	  grupa = "Chimist", -- you can add permissions
    r=255,g=125,b=0, -- color
    max_units=500,
    units_per_minute=10,
    x=1389.4887695313,y=3608.7172851563,z=38.941898345947,
    radius=2, height=1.5, -- area
    recipes = {
      ["Prelucreaza Experiment 1"] = { -- action name
        description="Faci experimente poate iti iese si tie ceva", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={
		      ["water"] = 5,
          ["drug_seeds"] = 3
		    }, -- items taken per unit
        products={
          ["cristalheroina"] = 1
		    }, -- items given per unit
        aptitudes={}
      },
      ["Prelucreaza Experiment 2"] = { -- action name
      description="Faci experimente poate iti iese si tie ceva", -- action description
      in_money=0, -- money taken per unit
      out_money=0, -- money earned per unit
      reagents={
        ["water"] = 10,
        ["drug_seeds"] = 6
      }, -- items taken per unit
      products={
        ["cristalcocaina"] = 1
      }, -- items given per unit
      aptitudes={}
    }
    }
  },
  {
  name="Traficant De Tigari", -- menu name
	permissions = {"harvest.tigari"}, -- job drug dealer required to use
    r=60,g=60,b=60, -- color
    max_units=10000,
    units_per_minute=10000,
    x= 2325.9860839844,y=2528.8586425781,z=46.667682647705, -- 2325.9860839844,2528.8586425781,46.667682647705
    radius=1.1, height=1.5, -- area
    recipes = {
      ["[1] Produ' Tigari"] = { -- action name
        description="Produci tigari.", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={ -- items taken per unit
          ["foitasall"] = 1,
          ["tutunsall"] = 10
        },
        products={ -- items given per unit
          ["tigarasall"] = 1
        },
      }
    }
  },
  {
    name="UPS Colete", -- menu name
    permissions = {"harvest.parcels"}, -- you can add permissions
    r=0,g=125,b=255, -- color
    max_units=100,
    units_per_minute=10,
    x=76.495727539063,y=-27.030916213989,z=68.562599182129,
    radius=3, height=1.5, -- area
    recipes = {
      ["Pachete si Colete"] = { -- action name
        description="Colecteaza Pachetele si Coletele", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["colete"] = 1
        }
      },
      ["Colete Cargo"] = { -- action name
        description="Colecteaza Coletele Cargo", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={ -- items given per unit
          ["cargo"] = 1
        }
      }
	  }
  },
  {
    name="Hacker", -- menu name
	  permissions = {"hacker.credit_cards"}, -- you can add permissions
    r=255,g=125,b=0, -- color
    max_units=50,
    units_per_minute=30,
    x=707.357238769531,y=-966.98876953125,z=30.4128551483154,
    radius=2, height=1.0, -- area
    recipes = {
      ["Hackuing cardurile de credit ale oamenilor"] = { -- action name
        description="Hackuieste carduri de credit ale oamenilor si dupa poti sa le transformi in Buletine Ilegale la Falsificator.", -- action description
        in_money=0, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={}, -- items taken per unit
        products={
		      ["credit"] = 1,
		    }, -- items given per unit
        aptitudes={ -- optional
          ["hacker.hacking"] = 0.2 -- "group.aptitude", give 1 exp per unit
        }
      }
    }
  },
  {
    name="Fabrica de Alcool", -- menu name
	  permissions = {"vin.bun"}, -- job drug dealer required to use
    r=0,g=255,b=0, -- color
    max_units=100,
    units_per_minute=10,
    x=-87.517410278327,y=6228.0458984375,z=31.089908599854, -- pos (needed for public use lab tools)
    radius=1.1, height=1.5, -- area
    recipes = {
      ["Vin Rosu"] = { -- action name
        description="Sa facem Vin rosu bun! Ai nevoie de o Sticla Goala si 2 struguri", -- action description
        in_money=100, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={ -- items taken per unit
          ["pet"] = 1,
		      ["struguri"] = 2
        },
        products={ -- items given per unit
          ["vin"] = 1
        },
        aptitudes={ -- optional
          ["science.chemicals"] = 3
        }
      },
      ["Tuica de Mere"] = { -- action name
        description="Sa facem niste tuica! Ai nevoie de o Sticla Goala si 2 mere", -- action description
        in_money=100, -- money taken per unit
        out_money=0, -- money earned per unit
        reagents={ -- items taken per unit
          ["mere"] = 2,
		      ["pet"] = 1
        },
        products={ -- items given per unit
          ["tuica"] = 2,
        },
        aptitudes={ -- optional
          ["science.chemicals"] = 3
        }
      },
      ["Vin Alb"] = { -- action name
          description="Sa facem vin alb de calitate! Ai nevoie de o Sticla Goala si 2 struguri", -- action description
          in_money=500, -- money taken per unit
          out_money=0, -- money earned per unit
          reagents={ -- items taken per unit
            ["strugure"] = 2,
			      ["pet"] = 1
          },
          products={ -- items given per unit
            ["vins"] = 3
          },
          aptitudes={ -- optional
            ["science.chemicals"] = 3
        }
      }
	  }
  },
}

return cfg
