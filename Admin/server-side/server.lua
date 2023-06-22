-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("admin",cRP)
vCLIENT = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gemas",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local ID = parseInt(args[1])
			local Amount = parseInt(args[2])
			local identity = vRP.userIdentity(ID)
			if identity then
				vRP.execute("accounts/infosUpdategems",{ steam = identity["steam"], gems = Amount })
				TriggerClientEvent("Notify",source,"verde","<b>"..Amount.."</b> GEMAS creditados para o id <b>"..ID.."</b>",5000)
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042948565351288902/A1qKPz5_ZUomeMHTGuhZkVfhVYYJLHE2DERz1gZMmFAl8zfYcS33_B34aLHfTROzUQX_",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: GEMAS ( Foi adicionado **"..args[2].."** GEMAS ao ID: **"..ID.."** ). Caso seja algo suspeito olhe IMEDIATAMENTE```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADICIONAR DINHEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addmoney",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local idUser = parseInt(args[1])
			local quantidade = args[2]
			vRP.addBank(idUser,quantidade,"Private")
			TriggerClientEvent("Notify",source,"verde","<b>"..quantidade.."</b> dólares creditados para o id <b>"..idUser.."</b>",5000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042948879760494602/3qBK-4HW_GrYjxTRCVXN6T_bplz6qO22Fkb11bz2K7SEWmovasm-eChzX9PIJO__DCRk",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: ADDMONEY ( Foi adicionado **"..args[2].."** dolares ao ID: **"..idUser.."** ). Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Colocar fome e sede
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local idUser = parseInt(args[1])
			vRP.downgradeHunger(idUser,100)
			vRP.downgradeThirst(idUser,100)
			TriggerClientEvent("Notify",source,"verde","O id <b>"..idUser.."</b> agora tá morrendo de <b>fome</b> e <b>sede</b>",5000)
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- CONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cone",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") then
		TriggerClientEvent("cone",source,args[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARREIRA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("barreira",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Police") or vRP.hasPermission(user_id,"Paramedic") then
		TriggerClientEvent("barreira",source,args[1])
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("status",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    
    if vRP.hasGroup(user_id, "Admin") then
        local users = vRP.userList()
        local players = ""
        local quantidade = 0
        for k,v in pairs(users) do
            if k ~= #users then
                players = players..", "
            end
            players = players..k
            quantidade = quantidade + 1
        end
        TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{1, 136, 0},quantidade)
        TriggerClientEvent('chatMessage',source,"ID's ONLINE",{1, 136, 0},players)
		PerformHttpRequest("https://discordapp.com/api/webhooks/1042949440232755321/JvUPiHKThEKyG8wYk6QaNBOMuiJqboknd4ZOcZRJGitwNJikWzP_-VZ4SbR2rHx5r95u",function(err,text,headers) end,"POST",json.encode({
			content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: status. Caso seja algo suspeito olhe IMEDIATAMENTE```"
		}),{ ["Content-Type"] = "application/json" })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vRPC.blipsAdmin(source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042949576484716554/e0wLCHTT6EFLUQePSxyoU72a9PA_z8FxjGRgtTzp_zt2Z7NW7AXUq29GSn3q1z6kTami",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: blips. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dm',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserSource(parseInt(args[1]))
    if vRP.hasPermission(user_id,"Admin") then
        if args[1] == nil then
            TriggerClientEvent("Notify",source,"negado","Necessário passar o ID após o comando, exemplo: <b>/dm 1</b>")
            return
        elseif nplayer == nil then
            TriggerClientEvent("Notify",source,"negado","O jogador não está online!")
            return
        end
        local mensagem = vRP.prompt(source,"Digite a mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("Notify",source,"sucesso","Mensagem enviada com sucesso!")
        TriggerClientEvent('chatMessage',nplayer,"MENSAGEM DA ADMINISTRAÇÃO:",{50,205,50},mensagem)
        TriggerClientEvent("Notify",nplayer,"aviso","<b>Mensagem da Administração:</b> "..mensagem.."",50000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RG2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rg2',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "Admin") then
        
        if args[1] then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			local infoAccount = vRP.infoAccount(identity["steam"])

			local usergroups = vRP.getUserGroups(nuser_id)
			local groups = "Nenhum"

			if usergroups then
				local datagroups = {}

				for k, v in pairs(usergroups) do
					table.insert(datagroups, "<b>"..k.."</b>")
				end

				groups = table.concat(datagroups, "<br>")
			end

           	TriggerClientEvent("Notify",source,"azul","ID: <b>"..parseInt(nuser_id).."</b><br>Nome: <b>"..identity["name"].." "..identity["name2"].."</b><br>Fone: <b>"..identity["phone"].."</b><br>Banco: <b>"..vRP.getBank(nuser_id).."</b><br>Garagens: <b>"..identity["garage"].."</b><br>Localização: <b>"..identity["locate"].."</b><br>Porte de Armas: <b>"..identity["port"].."</b><br>Personagens: <b>"..infoAccount["chars"].."</b><br>Serial: <b>"..identity["serial"].."</b><br>STEAM HEX: <b>"..identity["steam"].."</b><br>GRUPOS: "..groups.."",10000)    
        else
            TriggerClientEvent("Notify",source,"vermelho","Digite o ID desejado!")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RENOMEAR MORADORES
-----------------------------------------------------------------------------------------------------------------------------------------


local wb = "https://discord.com/api/webhooks/1093064293303472148/8lMxiqj9R6vZam9Up81dROMRvjaoU8aarZSvAprkwG7S8mCS0IHz5Lu9i3H7wOHeVLiv"
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    local source = source
    local user_id = vRP.getUserId(source)

    local identity = vRP.getUserIdentity(user_id)
    local discord = ""
    local id = ""
    identifiers = GetNumPlayerIdentifiers(source)
    for i = 0, identifiers + 1 do
        if GetPlayerIdentifier(source, i) ~= nil then
            if string.match(GetPlayerIdentifier(source, i), "discord") then
                discord = GetPlayerIdentifier(source, i)
                id = string.sub(discord, 9, -1)
                
            end
        end
    end    
SendWebhookMessage(wb, "".. id..",".. identity.user_id ..","..identity.name ..",".. identity.name2)
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- ugroups
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ugroups',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "Admin") then
        if args[1] then
			local usergroups = vRP.getUserGroups(args[1])
			local groups = "Nenhum"

			if usergroups then
				local datagroups = {}

				for k, v in pairs(usergroups) do
					table.insert(datagroups, "<b>"..k.."</b>")
				end

				groups = table.concat(datagroups, "<br>")
			end

           	TriggerClientEvent("Notify",source,"azul","GRUPOS: "..groups.."",10000)    
        else
            TriggerClientEvent("Notify",source,"vermelho","Digite o ID desejado!")
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER ON
-----------------------------------------------------------------------------------------------------------------------------------------
--Citizen.CreateThread(function()
--    PerformHttpRequest("https://discord.com/api/webhooks/1055997615562567730/iMXwVcmHtFabMKoKHiU54DEmyfkAKP2wnt-BrEtjP5eVn71khShq2_jcuFj5wPZI7BBo", function(err, text, headers) end, 'POST', json.encode({
--        
--        embeds = {
--            {
--                description = '**SERVIDOR ONLINE:**\n\nAperte F8 e cole: connect cfx.re/join/9rm3my',
--                color = 2723266 -- Se quiser mudar a cor é aqui
--            }
--        }
--    }), { ['Content-Type'] = 'application/json' })
--end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- PTR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ptr",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local police = vRP.numPermission("Police")
    local paramedic = vRP.numPermission("Paramedic")
    local mechanic = vRP.numPermission("Mechanic")
        if user_id then
			if vRP.hasGroup(user_id,"Admin") then
            TriggerClientEvent("Notify",source,"sucesso","<b>👮 • Policia: "..#police.." <br>👨‍⚕️ • Paramedico: "..#paramedic.."<br>👨🏻‍🏭 • Mecânico: "..#mechanic.."",3000)
			end
		end
end) 
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"stream") then
			if args[1] then
				local nuser_id = parseInt(args[1])
				local otherPlayer = vRP.userSource(nuser_id)
				if otherPlayer then
					vRP.upgradeThirst(nuser_id,100)
					vRP.upgradeHunger(nuser_id,100)
					vRP.downgradeStress(nuser_id,100)
					vRPC.revivePlayer(otherPlayer,200)
					PerformHttpRequest("https://discordapp.com/api/webhooks/1042949673196982334/D-x6dCtVLCy9DLJYTfOiNxgTMJP5uZm_mXsGEtkfmyhn9b1y_A9C9v5tuT18bjLDmMsz",function(err,text,headers) end,"POST",json.encode({
						content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: god para o ID: **"..args[1].."** . Caso seja algo suspeito olhe IMEDIATAMENTE```"
					}),{ ["Content-Type"] = "application/json" })
				end
			else
				vRP.setArmour(source,100)
				vRPC.revivePlayer(source,200)
				vRP.upgradeThirst(user_id,100)
				vRP.upgradeHunger(user_id,100)
				vRP.downgradeStress(user_id,100)
				TriggerClientEvent("resetHandcuff",source)
				TriggerClientEvent("resetBleeding",source)
				TriggerClientEvent("resetDiagnostic",source)
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042949673196982334/D-x6dCtVLCy9DLJYTfOiNxgTMJP5uZm_mXsGEtkfmyhn9b1y_A9C9v5tuT18bjLDmMsz",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: god para si próprio. Caso seja algo suspeito olhe IMEDIATAMENTE```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VALEGOD
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if args[1] and args[2] and itemBody(args[1]) ~= nil then
				vRP.generateItem(user_id,args[1],parseInt(args[2]),true)
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042949905213313054/WUDNFIIliJdoGEZAcG_6gWlluYtjrgpl1Nnv3AzTeUaPym9lGTeLlMJIYhRT9B6BWjz1",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de SPAWNAR **"..args[2].."** **"..args[1].."** para seu inventário. Caso seja algo suspeito olhe imediatamente```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRIORITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("priority",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and parseInt(args[1]) > 0 then
		if vRP.hasGroup(user_id,"Admin") then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				TriggerClientEvent("Notify",source,"verde","Prioridade adicionada.",5000)
				vRP.execute("accounts/setPriority",{ steam = identity["steam"], priority = 99 })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		if vRP.hasGroup(user_id,"Admin") then
			local nuser_id = parseInt(args[1])
			vRP.execute("characters/removeCharacters",{ id = nuser_id })
			TriggerClientEvent("Notify",source,"verde","Personagem <b>"..nuser_id.."</b> deletado.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vRPC.noClip(source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042950150001262653/rnApxg-9z1lesnx-xoln5BWXMz-FUU9vc232zFseDEPZVE-UE87gd2w4l-a2nnp1l89P",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de usar o COMANDO: NC```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC STREAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ncs",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"stream") then
			vRPC.noClip(source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042950353534062612/05H6mjaetzGQ_x0PDFCba0j5qizbHh9Dojpk-1TRZ4-QLP8Gqum_hXZlX2OAKkW15z2S",function(err,text,headers) end,"POST",json.encode({
				content = "```O stream de passaporte **"..user_id.."** acaba de usar o COMANDO: NCS```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") or vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..args[1].."</b> expulso.",5000)
			vRP.kick(args[1],"Você foi kickado da cidade. Pense no que possa esta errado ou abra um ticket!")
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042950455979950160/CxtriFeR6zsG_7NAfcOghw2Ob5ljYK9685y_LLJ-7CwpuZU-OwJlG3psAHJfmN2mLuay",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de KICKAR o passaporte **"..args[1].."**```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") or vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Suporte") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
			local time = parseInt(args[2])
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.kick(nuser_id,"Banido.")
				vRP.execute("banneds/insertBanned",{ steam = identity["steam"], time = time })
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..nuser_id.."</b> banido por <b>"..time.." dias.",5000)
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042950581330911322/i3tYl4p9-Etfh8h84CNTYonM5XjD706nFNcUOUKumnnGcQVxMYS-kUIdlprm4bxLDE1a",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de BANIR o passaporte **"..nuser_id.."** por **"..time.."** dias!```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") or vRP.hasGroup(user_id,"Admin") and parseInt(args[1]) > 0 then
			local nuser_id = parseInt(args[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.execute("banneds/removeBanned",{ steam = identity["steam"] })
				TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..nuser_id.."</b> desbanido.",5000)
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042950749291810967/2kGkrTzVv7TIxMXRmG4gqmCVSuMpE4lEAVa5aFcW7V3gN9tt5VCDdk-OeBOfjV2mfUge",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de DESBANIR o passaporte **"..nuser_id.."**```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			local fcoords = vRP.prompt(source,"Cordenadas:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end

			vRP.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042951042901475368/u07N8jDBjqdw6ZF390W-fgd0CL3ZyTJY0Z0TnPxdWIRzuWLr6FpmjNB4l8T2WC5Sa1Gm",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de usar o comando TPCDS. Caso isso seja suspeito, verifique AGORA!```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.prompt(source,"Cordenadas:",mathLegth(coords["x"])..","..mathLegth(coords["y"])..","..mathLegth(coords["z"])..","..mathLegth(heading))
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042951248049086518/NU4SoYTmWvv4XSi6ua_lDGVibVDmy07qogVsus5pE3QiFHleZmFntGJ_33Qec8YjpoSD",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: cds. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or user_id == 1 and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Adicionado <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			vRP.setPermission(args[1],args[2])
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042952648204234903/N0uYe1nf7Qp5lHg0fecrdgUdc2K_6zXIrD0ZRGQb5K63LNIVxZSeqanDR7ZNcB_TvvT5",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de adicionar ao grupo: **"..args[2].."** o passaporte **"..args[1].."**. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 and args[2] then
			TriggerClientEvent("Notify",source,"verde","Removido <b>"..args[2].."</b> ao passaporte <b>"..args[1].."</b>.",5000)
			vRP.remPermission(args[1],args[2])
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042952887514439842/kXv9V_l_ZJ45TnL_vgwcmlLy7inMbzbKaCQSVSbrhnMgDaTAnGFbylJUocHiUmZ2aR5L",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte: **"..user_id.."** acaba de remover do grupo **"..args[2].."** o passaporte **"..args[1].."**. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)

				vRP.teleport(otherPlayer,coords["x"],coords["y"],coords["z"])
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042953052233150534/jmyKYIKAQykn6WFX5uL5kz1VMiV0l0NaTOUI6tT8kZB9MEvLlnDqoYnUKyYg49XmLHH0",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: tptome puxando o ID: **"..args[1].."** . Caso seja algo suspeito olhe IMEDIATAMENTE```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") and parseInt(args[1]) > 0 then
			local otherPlayer = vRP.userSource(args[1])
			if otherPlayer then
				local ped = GetPlayerPed(otherPlayer)
				local coords = GetEntityCoords(ped)
				vRP.teleport(source,coords["x"],coords["y"],coords["z"])
				PerformHttpRequest("https://discordapp.com/api/webhooks/1042953229773844622/goPN6Qu1yFj-uxsuyrFOeQvclvbedwYIGuDYrUDGwEsM_krpxIKteds5CzM8DMLufixG",function(err,text,headers) end,"POST",json.encode({
					content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: tpto. Caso seja algo suspeito olhe IMEDIATAMENTE```"
				}),{ ["Content-Type"] = "application/json" })
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vCLIENT.teleportWay(source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042955238665105409/1IbAiln_Ni6ukIa-c1vVQVOgLL8X9ff6OISqrp5zlH7nQKappyRoTlcTSgqcB7iqNBhX",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: tpway. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			vCLIENT.teleportLimbo(source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042955238665105409/1IbAiln_Ni6ukIa-c1vVQVOgLL8X9ff6OISqrp5zlH7nQKappyRoTlcTSgqcB7iqNBhX",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: limbo. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hash",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local vehicle = vRPC.vehicleHash(source)
			if vehicle then
				vRP.prompt(source,"HASH: "..vehicle,vehicle)
				-- vRP.updateTxt("hash.txt",vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			TriggerClientEvent("admin:vehicleTuning",source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042955495914340383/Swva3TjhUiZkHETj4ANpeeBpOeEj0R22tlsd3EzZ2U0l5jNrqHZxWjvdtHnCtfrDH9HS",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: tuning. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") or vRP.hasGroup(user_id,"stream") then
			local vehicle,vehNet,vehPlate = vRPC.vehList(source,10)
			if vehicle then
				local activePlayers = vRPC.activePlayers(source)
				for _,v in ipairs(activePlayers) do
					async(function()
						TriggerClientEvent("inventory:repairAdmin",v,vehNet,vehPlate)
						PerformHttpRequest("https://discordapp.com/api/webhooks/1042955758356144138/JfJM84a4bgnZJsbM8SxJn-8iGbfrR11wBNp_1n4zzzr4VO4VEVkUzVSdcaEnPUZ8OacC",function(err,text,headers) end,"POST",json.encode({
							content = "```O passaporte **"..user_id.."** acaba de REALIZAR FIX em um veiculo! Caso seja algo suspeito olhe IMEDIATAMENTE```"
						}),{ ["Content-Type"] = "application/json" })
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparlocal",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)

			local activePlayers = vRPC.activePlayers(source)
			for _,v in ipairs(activePlayers) do
				async(function()
					TriggerClientEvent("syncarea",v,coords["x"],coords["y"],coords["z"],100)
					PerformHttpRequest("https://discordapp.com/api/webhooks/1042956870970785843/41mcAdG0x19ukpWGrhlDrkZRbj5caTHPZOFfDVxhUakVeIb-vleOx6fWKXuw5FEWlziw",function(err,text,headers) end,"POST",json.encode({
						content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: limparlocal . Caso seja algo suspeito olhe IMEDIATAMENTE```"
					}),{ ["Content-Type"] = "application/json" })
				end)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			TriggerClientEvent("Notify",source,"azul","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),5000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042957042559750204/FQedoG5_ivcMLgg-frz5ANkJ-UtatZp5eukwNHaHrpqtryBWbHxQzcdHX9fJYTN9MMnT",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: PLAYERS . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.buttonTxt()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			vRP.updateTxt(user_id..".txt",mathLegth(coords.x)..","..mathLegth(coords.y)..","..mathLegth(coords.z)..","..mathLegth(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio PRESIDENTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("presidente",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","PRESIDENTE: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042966825207595018/fdXkPTIvnr1CPtmE-nL_h88bv9tw8zZbcP13Uq-YId8NJ8P5-qS00QSqCTmZTFrCKBOj",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: presidente deixando a seguinte mensagem: **"..message.."** ( anúncio como PRESIDENTE ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio GOVERNADOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("governador",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","GOVERNADOR: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042967046247415858/2KpuThBptWUw8-C6-PUbpLLlepofkCYyKzkbTpe_7OItofUNJio1ZzzHIsHHUpPgH-4M",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: governador deixando a seguinte mensagem: **"..message.."** ( anúncio como GOVERNADOR ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio PREFEITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("prefeito",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","PREFEITO: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042966948117487657/v9ErkZ0J47rQlYVwRsIvtR4zend2iz4HIA9KVMR_FLUK81Xb16MLNlOBCOltVqkoOoKb",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: prefeito deixando a seguinte mensagem: **"..message.."** ( anúncio como PREFEITO ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio AMARELO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Mechanic")then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"amarelo",message,60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042958046067957780/UGGpL-Ma1ApJjy_78IB8LqgGwvdFyf8xahm0rycfNIu-_jHSMJlmHyujvF9Jvn_d5GCG",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: anuncio deixando a seguinte mensagem: **"..message.."** ( anúncio como EMERGENCIA ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio AMARELO MECANICO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mecanica",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Mechanic") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"amarelo","MECANICA: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042958046067957780/UGGpL-Ma1ApJjy_78IB8LqgGwvdFyf8xahm0rycfNIu-_jHSMJlmHyujvF9Jvn_d5GCG",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: anuncio deixando a seguinte mensagem: **"..message.."** ( anúncio como EMERGENCIA ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio AMARELO POLICIA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("policia",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Police") or vRP.hasGroup(user_id,"Lspd") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"amarelo","POLICIA: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042958046067957780/UGGpL-Ma1ApJjy_78IB8LqgGwvdFyf8xahm0rycfNIu-_jHSMJlmHyujvF9Jvn_d5GCG",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: policia deixando a seguinte mensagem: **"..message.."** ( anúncio como EMERGENCIA ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio AMARELO HOSPITAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hospital",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Paramedic") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"amarelo","HOSPITAL: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042958046067957780/UGGpL-Ma1ApJjy_78IB8LqgGwvdFyf8xahm0rycfNIu-_jHSMJlmHyujvF9Jvn_d5GCG",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: anuncio deixando a seguinte mensagem: **"..message.."** ( anúncio como EMERGENCIA ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Anuncio AMARELO SHOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("show",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"stream") then
			local message = vRP.prompt(source,"Mensagem:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"amarelo","SHOW ANITTA: <b>"..message.."</b>.",60000)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042958046067957780/UGGpL-Ma1ApJjy_78IB8LqgGwvdFyf8xahm0rycfNIu-_jHSMJlmHyujvF9Jvn_d5GCG",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: anuncio deixando a seguinte mensagem: **"..message.."** ( anúncio como EMERGENCIA ) . Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if source == 0 then
		local playerList = vRP.userList()
		for k,v in pairs(playerList) do
			vRP.kick(k,"Desconectado, a cidade reiniciou.")
			Citizen.Wait(100)
		end

		TriggerEvent("admin:KickAll")
	elseif user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local playerList = vRP.userList()
			for k,v in pairs(playerList) do
				vRP.kick(k,"Desconectado, a cidade reiniciou.")
				Citizen.Wait(100)
			end

			TriggerEvent("admin:KickAll")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("itemall",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			local playerList = vRP.userList()
			for k,v in pairs(playerList) do
				async(function()
					vRP.generateItem(k,tostring(args[1]),parseInt(args[2]),true)
				end)
			end

			TriggerClientEvent("Notify",source,"verde","Envio concluído.",10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local checkPoints = 0
function cRP.raceCoords(vehCoords,leftCoords,rightCoords)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		checkPoints = checkPoints + 1

		vRP.updateTxt("races.txt","["..checkPoints.."] = {")

		vRP.updateTxt("races.txt","{ "..mathLegth(vehCoords["x"])..","..mathLegth(vehCoords["y"])..","..mathLegth(vehCoords["z"]).." },")
		vRP.updateTxt("races.txt","{ "..mathLegth(leftCoords["x"])..","..mathLegth(leftCoords["y"])..","..mathLegth(leftCoords["z"]).." },")
		vRP.updateTxt("races.txt","{ "..mathLegth(rightCoords["x"])..","..mathLegth(rightCoords["y"])..","..mathLegth(rightCoords["z"]).." }")

		vRP.updateTxt("races.txt","},")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar",function(source,args,rawCommand,vehName)
    local source = source
    local user_id = vRP.getUserId(source)
    
    if vRP.hasGroup(user_id, "Admin") then
		vRP.execute("vehicles/addVehicles",{ user_id = parseInt(args[1]), vehicle = tostring(args[2]), plate = vRP.generatePlate(), work = "false" })
		TriggerClientEvent("Notify",source,"verde","Carro ".." "..args[2].." adicionado para o id "..args[1],5000)

		PerformHttpRequest("https://discordapp.com/api/webhooks/1042968967653892208/m4PAtlCqwA9WlAm8NOkaxJYqiW_BjfD22PCwSzfo80dWL80OxHPQBQKFH0GEsljAIGxQ",function(err,text,headers) end,"POST",json.encode({
			content = "```O passaporte **"..user_id.."** adicionou **"..args[2].."** para o passaporte **"..args[1].."**```"
		}),{ ["Content-Type"] = "application/json" })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local target = parseInt(args[2])
    
    if vRP.hasGroup(user_id, "Admin") then
		vRP.execute("vehicles/removeVehicles",{ user_id = parseInt(args[1]), vehicle = args[2] })
		TriggerClientEvent("Notify",source,"verde","Carro ".." "..args[2].." removido do id "..args[1],5000)
		PerformHttpRequest("https://discordapp.com/api/webhooks/1042969142459895869/MW84qoiR_kCA2RVsydqbTdZRe0q8CaYiSCE8nlvd-K74_qGKSuVnJedLZyLX45i2wBNM",function(err,text,headers) end,"POST",json.encode({
			content = "```O passaporte **"..user_id.."** removeu **"..args[2].."** do passaporte **"..args[1].."**```"
		}),{ ["Content-Type"] = "application/json" })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("admindebug",function(source,args,rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,"Admin") then
            TriggerClientEvent("ToggleDebug",source)
			PerformHttpRequest("https://discordapp.com/api/webhooks/1042969458672664607/Wvxfj1ol6OA5a33Ovo_hTIDEZbPjdlr3s9Q093Fu521piV7iA5ofrnbUMzFzxnfqSKWq",function(err,text,headers) end,"POST",json.encode({
				content = "```O passaporte **"..user_id.."** acaba de utilizar o COMANDO: admindebug. Caso seja algo suspeito olhe IMEDIATAMENTE```"
			}),{ ["Content-Type"] = "application/json" })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PONTO GERAL
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('stream', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "Admin") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))
	  
	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "stream") then
		  -- Remove o cargo de stream do usuário
		  vRP.remPermission(user_id, "stream")
		  TriggerClientEvent("Notify",source,"sucesso","O seu grupo <b>stream</b> foi retirado.",5000)
		else
		  -- Adiciona o cargo de stream ao usuário
		  vRP.setPermission(user_id, "stream")
		  TriggerClientEvent("Notify",source,"sucesso","O seu grupo <b>stream</b> foi adicionado.",5000)
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui.",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)
  

  RegisterCommand('comandante', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "comandanteap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))
	   	  
	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "comandante") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "comandante")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitcomandante")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "comandante")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - COMANDANTE: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitcomandante")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('coronel', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "coronelap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))

	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "coronel") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "coronel")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitcoronel")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "coronel")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - CORONEL: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitcoronel")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)
  
  RegisterCommand('major', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "majorap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))

	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "major") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "major")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitmajor")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "major")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - MAJOR: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitmajor")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('capitao', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "capitaoap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))

	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "capitao") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "capitao")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitcapitao")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "capitao")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - CAPITÃO: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitcapitao")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('tenente', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "tenenteap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))

	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "tenente") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "tenente")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waittenente")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "tenente")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - TENENTE: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waittenente")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('sargento', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "sargentoap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))

	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "sargento") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "sargento")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitsargento")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "sargento")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - SARGENTO: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitsargento")
		  end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('cabo', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "caboap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))
	  
	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "cabo") then
			-- Remove o cargo de stream do usuário
			vRP.remPermission(user_id, "cabo")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
			vRP.removePermission(user_id,"Police")
			  TriggerEvent("blipsystem:serviceExit",source)
			  TriggerClientEvent("vRP:PoliceService",source,false)
			  vRP.setPermission(user_id,"waitcabo")
		  else
			-- Adiciona o cargo de stream ao usuário
			vRP.setPermission(user_id, "cabo")
			TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
			vRP.insertPermission(source,user_id,"Police")
				  TriggerClientEvent("vRP:PoliceService",source,true)
				  TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - CABO: "..identity["name"].." "..identity["name2"],Color)
				  vRP.remPermission(user_id, "waitcabo")
		  end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('soldado', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "soldadoap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))
	  
	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "soldado") then
		  -- Remove o cargo de stream do usuário
		  vRP.remPermission(user_id, "soldado")
		  TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
		  vRP.removePermission(user_id,"Police")
			TriggerEvent("blipsystem:serviceExit",source)
			TriggerClientEvent("vRP:PoliceService",source,false)
			vRP.setPermission(user_id,"waitsoldado")
		else
		  -- Adiciona o cargo de stream ao usuário
		  vRP.setPermission(user_id, "soldado")
		  TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
		  vRP.insertPermission(source,user_id,"Police")
				TriggerClientEvent("vRP:PoliceService",source,true)
				TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - SOLDADO: "..identity["name"].." "..identity["name2"],Color)
				vRP.remPermission(user_id, "waitsoldado")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até o balcão da delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)

  RegisterCommand('recruta', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
  
	if vRP.hasGroup(user_id, "recrutaap") then
	  -- Se o usuário estiver no grupo Admin
	  local ped = GetPlayerPed(source)
	  local coords = GetEntityCoords(ped)
	  local identity = vRP.userIdentity(user_id)
	  local distance = #(coords - vector3(441.81,-982.05,30.83))
	  
	  -- Verifica se o usuário está dentro da área e a uma distância máxima de 5 metros
	  if distance <= 5.0 then
		-- Verifica se o usuário tem o cargo de stream
		if vRP.hasGroup(user_id, "recruta") then
		  -- Remove o cargo de stream do usuário
		  vRP.remPermission(user_id, "recruta")
		  TriggerClientEvent("Notify",source,"sucesso","Você acaba de sair de serviço.",5000)
		  vRP.removePermission(user_id,"Police")
			TriggerEvent("blipsystem:serviceExit",source)
			TriggerClientEvent("vRP:PoliceService",source,false)
			vRP.setPermission(user_id,"waitrecruta")
		else
		  -- Adiciona o cargo de stream ao usuário
		  vRP.setPermission(user_id, "recruta")
		  TriggerClientEvent("Notify",source,"sucesso","Você acaba de entrar em serviço.",5000)
		  vRP.insertPermission(source,user_id,"Police")
				TriggerClientEvent("vRP:PoliceService",source,true)
				TriggerEvent("blipsystem:serviceEnter",source,"POLÍCIA - RECRUTA: "..identity["name"].." "..identity["name2"],Color)
				vRP.remPermission(user_id, "waitrecruta")
		end
	  else
		-- Se o usuário estiver fora da área
		TriggerClientEvent("Notify",source,"negado","Você não pode usar este comando aqui. Vá até a delegacia",5000)
	  end
	else
	  -- Se o usuário não estiver no grupo Admin
	  TriggerClientEvent("Notify",source,"negado","Você não tem permissão para usar este comando.",5000)
	end
  end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVER ITENS QUEBRADOS
-----------------------------------------------------------------------------------------------------------------------------------------

  RegisterCommand("lixo", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	local inventory = vRP.userInventory(user_id)

	for k,v in pairs(inventory) do
		if v["amount"] > 0 and vRP.checkBroken(v["item"]) then
			vRP.tryGetInventoryItem(user_id,v["item"],v["amount"],false,k)
		end
	end

	TriggerClientEvent("Notify",source,"negado","Os itens quebrados foram removidos.",5000)
end)



