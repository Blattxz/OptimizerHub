-- SCRIPT DE OTIMIZAÇÃO MÁXIMA 120 FPS (SEM GUI)
-- Versão Corrigida e Funcional

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- CONFIGURAÇÃO DE FPS
if setfpscap then
    setfpscap(120)
elseif sethiddenproperty then
    sethiddenproperty(game, "NetworkSettings.IncomingReplicationLag", 0)
end

-- OTIMIZAÇÃO COMPLETA DE ILUMINAÇÃO
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 0
    Lighting.Brightness = 0
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end)

-- REMOVER TODOS OS EFEITOS DE ILUMINAÇÃO
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

-- OTIMIZAÇÃO DE TERRENO
pcall(function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
        terrain.Decoration = false
    end
end)

-- CONFIGURAÇÕES DE RENDERIZAÇÃO
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

-- FUNÇÃO PRINCIPAL DE OTIMIZAÇÃO
local function OptimizarTudo()
    -- Otimizar Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            -- Remover Partículas
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
                obj.Rate = 0
            end
            
            -- Remover Trails
            if obj:IsA("Trail") then
                obj.Enabled = false
                obj.Lifetime = 0
            end
            
            -- Remover Beams
            if obj:IsA("Beam") then
                obj.Enabled = false
            end
            
            -- Remover Fogo/Fumaça/Sparkles
            if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            
            -- Remover Explosões
            if obj:IsA("Explosion") then
                obj.BlastPressure = 0
                obj.BlastRadius = 0
            end
            
            -- Desativar Luzes
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
                obj.Brightness = 0
            end
            
            -- Otimizar Partes
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end
            
            -- Otimizar MeshParts
            if obj:IsA("MeshPart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.TextureID = ""
                obj.CastShadow = false
            end
            
            -- Remover Decals/Textures
            if obj:IsA("Decal") then
                obj.Transparency = 1
            end
            
            if obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end)
    end
end

-- EXECUTAR OTIMIZAÇÃO INICIAL
OptimizarTudo()

-- OTIMIZAR PERSONAGEM DO JOGADOR
if Player.Character then
    for _, obj in pairs(Player.Character:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
            if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("PointLight") or obj:IsA("SpotLight") then
                obj.Enabled = false
            end
        end)
    end
end

-- OTIMIZAR QUANDO SPAWNAR
Player.CharacterAdded:Connect(function(char)
    wait(0.2)
    for _, obj in pairs(char:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = false
            end
            if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
            if obj:IsA("PointLight") or obj:IsA("SpotLight") then
                obj.Enabled = false
            end
        end)
    end
end)

-- MONITORAR NOVOS OBJETOS
Workspace.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") then
            obj.Enabled = false
            obj.Rate = 0
        elseif obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.TextureID = ""
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end)
end)

-- LOOP DE RE-OTIMIZAÇÃO (A cada 15 segundos)
spawn(function()
    while wait(15) do
        OptimizarTudo()
    end
end)

-- REMOVER SONS DESNECESSÁRIOS
spawn(function()
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            pcall(function()
                if not sound.Playing then
                    sound.Volume = 0
                end
            end)
        end
    end
end)

-- OTIMIZAÇÃO ADICIONAL DE PERFORMANCE
pcall(function()
    UserInputService.MouseIconEnabled = true
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

print("✅ Otimização Máxima Ativada - 120 FPS")
print("✅ Todos os efeitos visuais desabilitados")
print("✅ Performance maximizada sem GUI")
