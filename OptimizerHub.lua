-- SCRIPT DE OTIMIZAÇÃO 120 FPS - GRÁFICOS BAIXOS (SEM GUI)
-- Mantém os gráficos normais do jogo, apenas reduz a qualidade

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- CONFIGURAÇÃO DE FPS MÁXIMO
if setfpscap then
    setfpscap(120)
end

-- REDUZIR QUALIDADE GRÁFICA PARA BAIXO
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    settings().Rendering.EditQualityLevel = Enum.QualityLevel.Level01
end)

-- CONFIGURAÇÕES DE ILUMINAÇÃO (Mantém visual mas reduz qualidade)
pcall(function()
    Lighting.GlobalShadows = false  -- Desativa sombras (maior impacto em FPS)
    Lighting.EnvironmentDiffuseScale = 0.5  -- Reduz iluminação ambiente
    Lighting.EnvironmentSpecularScale = 0.5  -- Reduz reflexos ambientais
    
    -- Mantém as cores e ambiente do jogo normais
    -- Não altera: Brightness, FogEnd, OutdoorAmbient, Ambient
end)

-- REDUZIR QUALIDADE DE EFEITOS (Mantém mas com menos intensidade)
for _, effect in pairs(Lighting:GetChildren()) do
    pcall(function()
        if effect:IsA("BloomEffect") then
            effect.Intensity = effect.Intensity * 0.3  -- Reduz bloom em 70%
            effect.Size = 10
            effect.Threshold = 2
        elseif effect:IsA("BlurEffect") then
            effect.Size = effect.Size * 0.3  -- Reduz blur em 70%
        elseif effect:IsA("SunRaysEffect") then
            effect.Intensity = effect.Intensity * 0.3
        elseif effect:IsA("ColorCorrectionEffect") then
            -- Mantém correção de cor intacta
        elseif effect:IsA("DepthOfFieldEffect") then
            effect.FarIntensity = effect.FarIntensity * 0.5
            effect.NearIntensity = effect.NearIntensity * 0.5
        end
    end)
end

-- OTIMIZAR TERRENO (Mantém visual mas reduz detalhes)
pcall(function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0.05  -- Ondas mínimas mas visíveis
        terrain.WaterWaveSpeed = 5
        terrain.WaterReflectance = 0.1  -- Reflexo mínimo
        terrain.Decoration = false  -- Remove decoração extra
    end
end)

-- OTIMIZAR PARTÍCULAS (Reduz quantidade mas mantém ativas)
local function OtimizarParticulas()
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            -- Partículas - Reduz rate em 70%
            if obj:IsA("ParticleEmitter") and obj.Enabled then
                obj.Rate = math.max(1, obj.Rate * 0.3)
                obj.Lifetime = NumberRange.new(
                    obj.Lifetime.Min * 0.5, 
                    obj.Lifetime.Max * 0.5
                )
            end
            
            -- Trails - Reduz lifetime
            if obj:IsA("Trail") and obj.Enabled then
                obj.Lifetime = obj.Lifetime * 0.5
            end
            
            -- Fogo - Reduz tamanho
            if obj:IsA("Fire") and obj.Enabled then
                obj.Size = obj.Size * 0.5
            end
            
            -- Fumaça - Reduz opacidade e tamanho
            if obj:IsA("Smoke") and obj.Enabled then
                obj.Opacity = obj.Opacity * 0.5
                obj.Size = obj.Size * 0.5
            end
            
            -- Luzes - Reduz brilho e alcance
            if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                if obj.Enabled then
                    obj.Brightness = obj.Brightness * 0.6
                    obj.Range = obj.Range * 0.7
                end
            end
            
            -- Partes - Remove sombras mas mantém material e cor
            if obj:IsA("BasePart") then
                obj.CastShadow = false
                -- Mantém: Material, Color, Transparency, Reflectance
            end
            
            -- MeshParts - Remove sombras mas mantém texturas
            if obj:IsA("MeshPart") then
                obj.CastShadow = false
                -- Mantém: TextureID, Material, Color
            end
        end)
    end
end

-- EXECUTAR OTIMIZAÇÃO INICIAL
OtimizarParticulas()

-- OTIMIZAR PERSONAGEM DO JOGADOR
local function OtimizarPersonagem(character)
    if not character then return end
    
    for _, obj in pairs(character:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") and obj.Enabled then
                obj.Rate = math.max(1, obj.Rate * 0.3)
            end
            if obj:IsA("Trail") and obj.Enabled then
                obj.Lifetime = obj.Lifetime * 0.5
            end
            if obj:IsA("PointLight") or obj:IsA("SpotLight") then
                if obj.Enabled then
                    obj.Brightness = obj.Brightness * 0.6
                    obj.Range = obj.Range * 0.7
                end
            end
        end)
    end
end

-- Otimizar personagem atual
if Player.Character then
    OtimizarPersonagem(Player.Character)
end

-- Otimizar quando spawnar
Player.CharacterAdded:Connect(function(char)
    wait(0.5)
    OtimizarPersonagem(char)
end)

-- MONITORAR NOVOS OBJETOS
Workspace.DescendantAdded:Connect(function(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") then
            wait(0.1)
            if obj.Enabled then
                obj.Rate = math.max(1, obj.Rate * 0.3)
                obj.Lifetime = NumberRange.new(
                    obj.Lifetime.Min * 0.5, 
                    obj.Lifetime.Max * 0.5
                )
            end
        elseif obj:IsA("Trail") then
            wait(0.1)
            if obj.Enabled then
                obj.Lifetime = obj.Lifetime * 0.5
            end
        elseif obj:IsA("Fire") then
            wait(0.1)
            if obj.Enabled then
                obj.Size = obj.Size * 0.5
            end
        elseif obj:IsA("Smoke") then
            wait(0.1)
            if obj.Enabled then
                obj.Opacity = obj.Opacity * 0.5
                obj.Size = obj.Size * 0.5
            end
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            wait(0.1)
            if obj.Enabled then
                obj.Brightness = obj.Brightness * 0.6
                obj.Range = obj.Range * 0.7
            end
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.CastShadow = false
        end
    end)
end)

-- LOOP DE RE-OTIMIZAÇÃO (A cada 20 segundos, suave)
spawn(function()
    while wait(20) do
        OtimizarParticulas()
    end
end)

-- OTIMIZAÇÃO DE ÁUDIO (Reduz qualidade mas mantém sons)
spawn(function()
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            pcall(function()
                -- Mantém sons importantes, reduz volume dos menos importantes
                if not sound.Playing and sound.Volume > 0.5 then
                    sound.Volume = sound.Volume * 0.7
                end
            end)
        end
    end
end)

print("✅ Otimização 120 FPS Ativada")
print("✅ Gráficos mantidos em qualidade BAIXA")
print("✅ Performance melhorada sem perder visual")
