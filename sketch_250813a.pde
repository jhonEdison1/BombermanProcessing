String[] mapa;
int tileSize = 40;
int filas = 10;
int columnas = 10;
boolean gameOver = false;
int mapaFilas = 50;
int mapaColumnas = 50;
int viewportFilas = 10;
int viewportColumnas = 10;
int viewportX = 0; // esquina superior izquierda de la ventana
int viewportY = 0;
int proximoEstado = 0; // 0: menú, 1: juego, 2: puntajes, 3: editor
String mapaElegido = "mapa.txt"; // Nombre del mapa por defecto

Escenario escenario;
Personaje personaje;
ArrayList<Bomba> bombas = new ArrayList<Bomba>();
ArrayList<Enemigo> enemigos = new ArrayList<Enemigo>();

int estado = 0; // 0: menú, 1: juego, 2: puntajes, 3: editor
int editorX = 0, editorY = 0; // posición del cursor en el editor
char editorBloque = '#'; // bloque seleccionado para colocar

JSONArray mapasJSON; // Para guardar el JSON completo
String[] nombresMapas; // Solo los nombres de los mapas
String[] descripcionesMapas; // Descripciones (opcional)
int mapaSeleccionado = 0; // Índice del mapa seleccionado

PImage imgAcero, imgLadrillo, imgPersonajeFrente;

void setup() {
  size(400, 400);
  mapasJSON = loadJSONArray("mapas.json");
  nombresMapas = new String[mapasJSON.size()];
  descripcionesMapas = new String[mapasJSON.size()];
  for (int i = 0; i < mapasJSON.size(); i++) {
    JSONObject obj = mapasJSON.getJSONObject(i);
    nombresMapas[i] = obj.getString("nombre");
    descripcionesMapas[i] = obj.getString("descripcion");
    // Si quieres usar "bloqueado", también puedes guardarlo aquí
  }
}

void draw() {
  background(240);
  if (estado == 0) {
    // Menú principal
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(0);
    text("Bomberman", width/2, 60);
    textSize(20);
    text("1. Jugar", width/2, 120);
    text("2. Puntajes", width/2, 160);
    text("3. Editor de mapa", width/2, 200);
    text("4. Salir", width/2, 240);
    textSize(14);
    if (gameOver) {
      fill(255, 0, 0);
      textSize(24);
      text("GAME OVER", width/2, 220);
    }
    text("Presiona 1, 2, 3 o 4", width/2, 280);
  } else if (estado == 1) {



    // Juego
    dibujarMapa();
    // El dibujo de bombas y personaje ya se realiza en dibujarMapa()
    fill(255, 0, 0);
    textSize(20);
    textAlign(LEFT, TOP);
    text("Vidas: " + personaje.vidas, 10, 10);
    if (personaje.vidas <= 0) {
      estado = 0;
      gameOver = true;

      personaje.vidas = 3;
      // Reiniciar el juego
      escenario = new Escenario(mapaFilas, mapaColumnas, tileSize, mapaElegido);
      // Buscar posición inicial del personaje en el mapa
      int px = 0, py = 0;
      for (int y = 0; y < mapaFilas; y++) {
        for (int x = 0; x < mapaColumnas; x++) {
          if (escenario.mapa[y].charAt(x) == 'P') {
            px = x;
            py = y;
          }
        }
      }
      personaje = new Personaje(px, py, tileSize);
      bombas.clear();
    }
    // Dibujar y actualizar bombas
    for (int i = bombas.size()-1; i >= 0; i--) {
      Bomba b = bombas.get(i);
      b.actualizar();
      // No llames a b.dibujar() aquí
      // Si la bomba explota, destruye bloques adyacentes
      if (b.estaExplotada()) {
        destruirBloques(b.x, b.y);
        if (personajeEnExplosion(b.x, b.y)) {
          personaje.perderVida();
        }
        bombas.remove(i);
      }
    }

    for (Enemigo enemigo : enemigos) {
      enemigo.mover(escenario.mapa, enemigo.getVelocidad(), true);
      int px = (enemigo.x - viewportX) * tileSize;
      int py = (enemigo.y - viewportY) * tileSize;
      if (enemigo.x >= viewportX && enemigo.x < viewportX + viewportColumnas &&
          enemigo.y >= viewportY && enemigo.y < viewportY + viewportFilas) {
        enemigo.dibujar(px, py);
      }
    }


  } else if (estado == 2) {
    // Puntajes (placeholder)
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Puntajes", width/2, 100);
    textSize(16);
    text("(Aquí irán los puntajes)", width/2, 150);
    text("Presiona ESC para volver", width/2, 250);
  } else if (estado == 3) {
    //azul claro
    background(100, 150, 255);
    textAlign(LEFT, TOP);
    textSize(16);
    fill(0);
    text("Editor de mapa", 10, 10);
    text("Flechas: mover cursor", 10, 30);
    text("1=# 2=. 3=_ 4=P", 10, 50);
    text("Espacio: colocar bloque", 10, 70);
    text("S: guardar mapa", 10, 90);
    text("ESC: volver al menú", 10, 110);

    // Calcula el área para el mapa (80% de la pantalla)
    int areaX = int(width * 0.1);
    int areaY = int(height * 0.15);
    int areaW = int(width * 0.8);
    int areaH = int(height * 0.8);

    // Calcula el tamaño de cada celda
    float miniTile = min(areaW / float(mapaColumnas), areaH / float(mapaFilas));

    // Dibuja el mapa
    for (int y = 0; y < mapaFilas; y++) {
      for (int x = 0; x < mapaColumnas; x++) {
        float px = areaX + x * miniTile;
        float py = areaY + y * miniTile;
        char c = escenario.mapa[y].charAt(x);
        if (c == '#') fill(80);
        else if (c == '.') fill(200, 100, 50);
        else if (c == '_') fill(240);
        else if (c == 'P') fill(0, 200, 255);
        rect(px, py, miniTile, miniTile);
        if (x == editorX && y == editorY) {
          stroke(255, 0, 0);
          strokeWeight(3);
          //noFill();
          rect(px, py, miniTile, miniTile);
          strokeWeight(1);
          stroke(180);
        }
      }
    }
    // Dibuja los números de columnas arriba
    textAlign(CENTER, CENTER);
    textSize(12);
    for (int x = 0; x < mapaColumnas; x++) {
      float px = areaX + x * miniTile + miniTile/2;
      float py = areaY - miniTile/2;
      fill(50, 50, 200);
      text(str(x+1), px, py);
    }
    // Dibuja los números de filas a la izquierda
    for (int y = 0; y < mapaFilas; y++) {
      float px = areaX - miniTile/2;
      float py = areaY + y * miniTile + miniTile/2;
      fill(50, 200, 50);
      text(str(y+1), px, py);
    }
    // Líneas  cada 10 celdas para simular habitaciones
    stroke(255, 255, 0);
    strokeWeight(2);
    for (int x = 0; x <= mapaColumnas; x += 10) {
      float px = areaX + x * miniTile;
      line(px, areaY, px, areaY + mapaFilas * miniTile);
    }
    for (int y = 0; y <= mapaFilas; y += 10) {
      float py = areaY + y * miniTile;
      line(areaX, py, areaX + mapaColumnas * miniTile, py);
    }
    strokeWeight(1);
    stroke(180); // Vuelve al color original
    // Coordenadas en tiempo real arriba
    fill(0);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Coordenada: (" + (editorX+1) + ", " + (editorY+1) + ")", 300, areaY - 30);
  } else  if (estado == 4) {
    background(240);
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Selecciona un mapa", width/2, 60);
    textSize(16);
    for (int i = 0; i < nombresMapas.length; i++) {
      if (i == mapaSeleccionado) fill(255, 255, 0); // Amarillo para el seleccionado
      else fill(0);
      text(nombresMapas[i] + " - " + descripcionesMapas[i], width/2, 120 + i * 30);
    }
    textSize(14);
    fill(0);
    text("Flechas para mover, ENTER para seleccionar", width/2, height - 40);
  }
}

void dibujarMapa() {
  // Actualiza la posición de la ventana según el personaje
  viewportX = constrain(personaje.x - viewportColumnas/2, 0, mapaColumnas - viewportColumnas);
  viewportY = constrain(personaje.y - viewportFilas/2, 0, mapaFilas - viewportFilas);

  for (int y = 0; y < viewportFilas; y++) {
    for (int x = 0; x < viewportColumnas; x++) {
      int mapaX = viewportX + x;
      int mapaY = viewportY + y;
      if (mapaX >= 0 && mapaX < mapaColumnas && mapaY >= 0 && mapaY < mapaFilas) {
        int px = x * tileSize;
        int py = y * tileSize;
        if (escenario.mapa[mapaY].length() > mapaX) {
          char c = escenario.mapa[mapaY].charAt(mapaX);
          if (c == '#') {
            image(escenario.imgAcero, px, py, tileSize, tileSize);
          } else if (c == '.') {
            image(escenario.imgLadrillo, px, py, tileSize, tileSize);
          }
        } else {
          // Si la línea es demasiado corta, dibuja un bloque rojo
          fill(255, 0, 0);
          rect(px, py, tileSize, tileSize);
        }
        stroke(180);
        noFill();
        rect(px, py, tileSize, tileSize);
      }
    }
  }
  // Dibuja bombas en la ventana
  for (int i = 0; i < bombas.size(); i++) {
    Bomba b = bombas.get(i);
    if (b.x >= viewportX && b.x < viewportX + viewportColumnas &&
      b.y >= viewportY && b.y < viewportY + viewportFilas) {
      int px = (b.x - viewportX) * tileSize;
      int py = (b.y - viewportY) * tileSize;
      b.dibujar(px, py); // Modifica Bomba para aceptar px, py
    }
  }
  // Dibuja el personaje en la ventana
  if (personaje.x >= viewportX && personaje.x < viewportX + viewportColumnas &&
    personaje.y >= viewportY && personaje.y < viewportY + viewportFilas) {
    int px = (personaje.x - viewportX) * tileSize;
    int py = (personaje.y - viewportY) * tileSize;
    personaje.dibujar(px, py); // Modifica Personaje para aceptar px, py
  }
}

void keyPressed() {
  if (estado == 0) {
    if (key == '1') {
      estado = 4; // Ir a selección de mapas antes de jugar
      proximoEstado = 1; // Guardar el estado del juego
    } else if (key == '2') {
      estado = 2;
    } else if (key == '3') {
      estado = 4; // Ir a selección de mapas antes de editar
      proximoEstado = 3; // Guardar el estado del editor
      surface.setSize(900, 900);
    } else if (key == '4') {
      exit();
    }
  } else if (estado == 1) {
    // Movimiento del personaje con flechas
    if (keyCode == UP) {
      personaje.mover(0, -1, escenario.mapa);
    } else if (keyCode == DOWN) {
      personaje.mover(0, 1, escenario.mapa);
    } else if (keyCode == LEFT) {
      personaje.mover(-1, 0, escenario.mapa);
    } else if (keyCode == RIGHT) {
      personaje.mover(1, 0, escenario.mapa);
    } else if (key == ' ') {
      // Colocar bomba en la posición actual del personaje
      bombas.add(new Bomba(personaje.x, personaje.y, tileSize));
    }
  } else if (estado == 3) {
    // Editor de mapa
    if (keyCode == UP) {
      editorY = max(0, editorY-1);
    } else if (keyCode == DOWN) {
      editorY = min(mapaFilas-1, editorY+1);
    } else if (keyCode == LEFT) {
      editorX = max(0, editorX-1);
    } else if (keyCode == RIGHT) {
      editorX = min(mapaColumnas-1, editorX+1);
    } else if (key == '1') {
      editorBloque = '#';
    } else if (key == '2') {
      editorBloque = '.';
    } else if (key == '3') {
      editorBloque = '_';
    } else if (key == '4') {
      editorBloque = 'P';
    } else if (key == ' ') {
      StringBuilder fila = new StringBuilder(escenario.mapa[editorY]);
      fila.setCharAt(editorX, editorBloque);
      escenario.mapa[editorY] = fila.toString();
    } else if (key == 's' || key == 'S') {
      // Guardar mapa
      saveStrings(mapaElegido, escenario.mapa);
    } else if (key == CODED && keyCode == ESC) {
      estado = 0;
      surface.setSize(400, 400);
    }
  } else if (estado == 2 && key == CODED && keyCode == ESC) {
    estado = 0;
  }

  if (estado == 4) {
    if (keyCode == UP) {
      mapaSeleccionado = (mapaSeleccionado - 1 + nombresMapas.length) % nombresMapas.length;
    } else if (keyCode == DOWN) {
      mapaSeleccionado = (mapaSeleccionado + 1) % nombresMapas.length;
    } else if (key == ENTER || key == RETURN) {
      mapaSeleccionado = constrain(mapaSeleccionado, 0, nombresMapas.length - 1);
      estado = proximoEstado; // Cambia al estado guardado
      mapaElegido = nombresMapas[mapaSeleccionado];

      //INICIALIZAR ESCENARIO
      escenario = new Escenario(mapaFilas, mapaColumnas, tileSize, mapaElegido);
      // Buscar posición inicial del personaje en el mapa
      int px = 0, py = 0;
      for (int y = 0; y < mapaFilas; y++) {
        for (int x = 0; x < mapaColumnas; x++) {
          if (escenario.mapa[y].charAt(x) == 'P') {
            px = x;
            py = y;
          }
        }
      }
      personaje = new Personaje(px, py, tileSize);
      viewportX = max(0, min(px - viewportColumnas/2, mapaColumnas - viewportColumnas));
      viewportY = max(0, min(py - viewportFilas/2, mapaFilas - viewportFilas));

      enemigos.clear();
      enemigos.add(new SoldadoEnemigo(5, 5, tileSize, 1, 1));


    } else if (key == CODED && keyCode == ESC) {
      estado = 0; // Volver al menú principal
    }
  }
}

// Destruye bloques destructibles ('.') en las 4 direcciones adyacentes
void destruirBloques(int bx, int by) {
  int[][] dirs = {{0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1}}; // centro y 4 lados
  for (int i = 0; i < dirs.length; i++) {
    int nx = bx + dirs[i][0];
    int ny = by + dirs[i][1];
    if (nx >= 0 && nx < mapaColumnas && ny >= 0 && ny < mapaFilas) {
      char c = escenario.mapa[ny].charAt(nx);
      if (c == '.') {
        StringBuilder fila = new StringBuilder(escenario.mapa[ny]);
        fila.setCharAt(nx, '_');
        escenario.mapa[ny] = fila.toString();
      }
    }
  }
}

boolean personajeEnExplosion(int bx, int by) {
  int[][] dirs = {{0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1}};
  for (int i = 0; i < dirs.length; i++) {
    int nx = bx + dirs[i][0];
    int ny = by + dirs[i][1];
    if (personaje.x == nx && personaje.y == ny) {
      return true;
    }
  }
  return false;
}
