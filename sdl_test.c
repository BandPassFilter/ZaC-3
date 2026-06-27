#define SDL_MAIN_HANDLED
#include <SDL3/SDL.h>
#include <stdbool.h>
#include <stdint.h>

SDL_Window* win;
SDL_Surface* surf;

#define WIDTH 960
#define HEIGHT 480

int main() {
  SDL_Init(SDL_INIT_VIDEO);
  win = SDL_CreateWindow(“Framebuffer Rendering!”, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
  surf = SDL_GetWindowSurface(window);
  
  bool quit = false;
  SDL_Event e;
  while (!quit) {
    while (SDL_PollEvent(&e)) {
      if (e.type == SDL_QUIT) {
        quit = true;
      }
    }
    SDL_UpdateWindowSurface(window);
  }
  
  SDL_DestroyWindow(window);
  SDL_Quit();
}