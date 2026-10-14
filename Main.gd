
extends Node3D

const VELOCIDADE := 6.0
var direcao := Vector2.ZERO
var jogador: CharacterBody3D
var camera: Camera3D

func _ready() -> void:
    jogador = CharacterBody3D.new()
    jogador.name = "Jogador"
    add_child(jogador)
    jogador.position = Vector3(0, 1, 0)

    var colisao := CollisionShape3D.new()
    var forma := CapsuleShape3D.new()
    forma.radius = 0.4
    forma.height = 1.8
    colisao.shape = forma
    jogador.add_child(colisao)

    var corpo := MeshInstance3D.new()
    var malha := CapsuleMesh.new()
    malha.radius = 0.4
    malha.height = 1.8
    corpo.mesh = malha
    corpo.material_override = StandardMaterial3D.new()
    corpo.material_override.albedo_color = Color(0.35, 0.2, 0.7)
    jogador.add_child(corpo)

    var chao := StaticBody3D.new()
    add_child(chao)
    var piso := MeshInstance3D.new()
    var plano := PlaneMesh.new()
    plano.size = Vector2(200, 200)
    piso.mesh = plano
    piso.material_override = StandardMaterial3D.new()
    piso.material_override.albedo_color = Color(0.24, 0.32, 0.25)
    chao.add_child(piso)

    var colisao_piso := CollisionShape3D.new()
    var forma_piso := BoxShape3D.new()
    forma_piso.size = Vector3(200, 0.2, 200)
    colisao_piso.shape = forma_piso
    chao.add_child(colisao_piso)
    chao.position.y = -0.1

    camera = Camera3D.new()
    jogador.add_child(camera)
    camera.position = Vector3(0, 4, 7)
    camera.rotation_degrees = Vector3(-18, 0, 0)
    camera.current = true

    criar_controles()

func _physics_process(delta: float) -> void:
    var teclado := Input.get_vector(
        "ui_left", "ui_right", "ui_up", "ui_down"
    )
    var movimento := direcao
    if teclado.length() > movimento.length():
        movimento = teclado

    jogador.velocity.x = movimento.x * VELOCIDADE
    jogador.velocity.z = movimento.y * VELOCIDADE

    if not jogador.is_on_floor():
        jogador.velocity.y -= 20.0 * delta
    else:
        jogador.velocity.y = 0.0

    jogador.move_and_slide()

func criar_controles() -> void:
    var camada := CanvasLayer.new()
    add_child(camada)

    var painel := HBoxContainer.new()
    painel.position = Vector2(20, 300)
    painel.add_theme_constant_override("separation", 8)
    camada.add_child(painel)

    criar_botao(painel, "◀", Vector2(-1, 0))
    criar_botao(painel, "▲", Vector2(0, -1))
    criar_botao(painel, "▼", Vector2(0, 1))
    criar_botao(painel, "▶", Vector2(1, 0))

func criar_botao(painel: HBoxContainer, texto: String,
        eixo: Vector2) -> void:
    var botao := Button.new()
    botao.text = texto
    botao.custom_minimum_size = Vector2(58, 58)
    painel.add_child(botao)

    botao.button_down.connect(func():
        direcao = eixo
    )
    botao.button_up.connect(func():
        if direcao == eixo:
            direcao = Vector2.ZERO
    )
