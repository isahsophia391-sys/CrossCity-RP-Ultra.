
extends Node3D

func _ready():
    criar_chao()
    criar_estrada()
    criar_predios()
    criar_jogador()
    criar_camera()
    criar_sol()

func material(cor: Color) -> StandardMaterial3D:
    var mat = StandardMaterial3D.new()
    mat.albedo_color = cor
    return mat

func bloco(nome: String, tamanho: Vector3, posicao: Vector3, cor: Color):
    var objeto = MeshInstance3D.new()
    objeto.name = nome
    var malha = BoxMesh.new()
    malha.size = tamanho
    objeto.mesh = malha
    objeto.position = posicao
    objeto.material_override = material(cor)
    add_child(objeto)

func criar_chao():
    var chao = MeshInstance3D.new()
    var malha = PlaneMesh.new()
    malha.size = Vector2(240, 240)
    chao.mesh = malha
    chao.material_override = material(Color(0.20, 0.36, 0.22))
    chao.position.y = -0.1
    add_child(chao)

func criar_estrada():
    bloco("Estrada_Principal", Vector3(14, 0.1, 220),
        Vector3(0, 0, 0), Color(0.12, 0.12, 0.14))
    bloco("Estrada_Cruzada", Vector3(220, 0.1, 14),
        Vector3(0, 0.02, 0), Color(0.12, 0.12, 0.14))

    for i in range(-90, 100, 20):
        bloco("Faixa", Vector3(0.3, 0.12, 6),
            Vector3(0, 0.1, i), Color(1, 0.9, 0.5))

func criar_predios():
    var cores = [
        Color(0.65, 0.68, 0.74),
        Color(0.78, 0.69, 0.56),
        Color(0.42, 0.50, 0.62),
        Color(0.72, 0.73, 0.76)
    ]

    var indice = 0

    for x in range(-70, 80, 22):
        for z in range(-70, 80, 24):
            if abs(x) < 18 or abs(z) < 18:
                continue

            var altura = 8 + (indice * 7) % 22

            bloco(
                "Predio_" + str(indice),
                Vector3(12, altura, 14),
                Vector3(x, altura / 2.0, z),
                cores[indice % cores.size()]
            )

            indice += 1

func criar_jogador():
    var jogador = MeshInstance3D.new()
    jogador.name = "Jogador_Teste"

    var malha = CapsuleMesh.new()
    malha.radius = 0.55
    malha.height = 2.0

    jogador.mesh = malha
    jogador.position = Vector3(4, 1, 4)
    jogador.material_override = material(Color(0.48, 0.18, 0.78))
    add_child(jogador)

func criar_camera():
    var camera = Camera3D.new()
    camera.name = "Camera3D"
    camera.position = Vector3(34, 30, 38)
    add_child(camera)

    camera.look_at(Vector3.ZERO, Vector3.UP)
    camera.current = true

func criar_sol():
    var sol = DirectionalLight3D.new()
    sol.name = "Sol"
    sol.rotation_degrees = Vector3(-55, -25, 0)
    sol.light_energy = 1.2
    add_child(sol)
