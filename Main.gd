extends Node3D

# CrossCity RP Ultra — nova base urbana 3D
# Protótipo visual: ainda não inclui multiplayer nem veículos dirigíveis.

const ROAD := Color(0.10, 0.11, 0.13)
const SIDEWALK := Color(0.48, 0.49, 0.48)
const GRASS := Color(0.16, 0.30, 0.17)

func _ready() -> void:
    criar_chao()
    criar_ruas()
    criar_quarteiroes()
    criar_praca()
    criar_jogador_teste()
    criar_iluminacao()
    criar_camera()

func material(cor: Color, rugosidade: float = 0.85) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = cor
    m.roughness = rugosidade
    return m

func cubo(nome: String, tamanho: Vector3, pos: Vector3, cor: Color) -> void:
    var obj := MeshInstance3D.new()
    obj.name = nome
    var malha := BoxMesh.new()
    malha.size = tamanho
    obj.mesh = malha
    obj.position = pos
    obj.material_override = material(cor)
    add_child(obj)

func criar_chao() -> void:
    var chao := MeshInstance3D.new()
    var malha := PlaneMesh.new()
    malha.size = Vector2(300, 300)
    chao.mesh = malha
    chao.material_override = material(GRASS)
    chao.position.y = -0.15
    add_child(chao)

func criar_ruas() -> void:
    for p in range(-120, 121, 60):
        cubo("Rua_vertical", Vector3(18, 0.12, 300),
            Vector3(p, 0, 0), ROAD)
        cubo("Calcada_esquerda", Vector3(3, 0.18, 300),
            Vector3(p - 10.5, 0.02, 0), SIDEWALK)
        cubo("Calcada_direita", Vector3(3, 0.18, 300),
            Vector3(p + 10.5, 0.02, 0), SIDEWALK)

        cubo("Rua_horizontal", Vector3(300, 0.12, 18),
            Vector3(0, 0.01, p), ROAD)
        cubo("Calcada_superior", Vector3(300, 0.18, 3),
            Vector3(0, 0.03, p - 10.5), SIDEWALK)
        cubo("Calcada_inferior", Vector3(300, 0.18, 3),
            Vector3(0, 0.03, p + 10.5), SIDEWALK)

func criar_quarteiroes() -> void:
    var cores: Array[Color] = [
        Color(0.66, 0.65, 0.62),
        Color(0.72, 0.70, 0.64),
        Color(0.43, 0.48, 0.52),
        Color(0.78, 0.77, 0.73),
        Color(0.57, 0.59, 0.60)
    ]

    var indice := 0

    for x in range(-100, 101, 60):
        for z in range(-100, 101, 60):
            if abs(x) < 25 and abs(z) < 25:
                continue

            var altura := 12.0 + float((indice * 13) % 34)
            var largura := 19.0 + float(indice % 3) * 3.0

            cubo("Edificio_%02d" % indice,
                Vector3(largura, altura, 20),
                Vector3(x, altura / 2.0, z),
                cores[indice % cores.size()])

            # Faixa escura na fachada para sugerir janelas.
            cubo("Fachada_vidros_%02d" % indice,
                Vector3(largura * 0.72, altura * 0.60, 0.18),
                Vector3(x, altura * 0.58, z + 10.11),
                Color(0.12, 0.22, 0.29))

            indice += 1

func criar_praca() -> void:
    cubo("Praca", Vector3(28, 0.15, 28),
        Vector3(0, 0.02, 0), Color(0.30, 0.37, 0.28))

    for p in [Vector2(-8, -8), Vector2(8, -8),
              Vector2(-8, 8), Vector2(8, 8)]:
        cubo("Arvore_tronco", Vector3(0.7, 3, 0.7),
            Vector3(p.x, 1.5, p.y), Color(0.28, 0.18, 0.10))
        cubo("Arvore_copa", Vector3(3.5, 3.5, 3.5),
            Vector3(p.x, 4, p.y), Color(0.12, 0.29, 0.13))

func criar_jogador_teste() -> void:
    var jogador := MeshInstance3D.new()
    jogador.name = "Marcador_Jogador"
    var malha := CapsuleMesh.new()
    malha.radius = 0.55
    malha.height = 2.0
    jogador.mesh = malha
    jogador.position = Vector3(4, 1, 4)
    jogador.material_override = material(Color(0.35, 0.18, 0.65))
    add_child(jogador)

func criar_iluminacao() -> void:
    var mundo := WorldEnvironment.new()
    var ambiente := Environment.new()
    ambiente.background_mode = Environment.BG_SKY
    ambiente.sky = Sky.new()
    ambiente.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    ambiente.ambient_light_color = Color(0.65, 0.72, 0.85)
    ambiente.ambient_light_energy = 0.65
    mundo.environment = ambiente
    add_child(mundo)

    var sol := DirectionalLight3D.new()
    sol.rotation_degrees = Vector3(-48, -25, 0)
    sol.light_energy = 1.1
    add_child(sol)

func criar_camera() -> void:
    var camera := Camera3D.new()
    camera.name = "Camera3D"
    camera.position = Vector3(42, 38, 48)
    add_child(camera)
    camera.look_at(Vector3.ZERO, Vector3.UP)
    camera.current = true
