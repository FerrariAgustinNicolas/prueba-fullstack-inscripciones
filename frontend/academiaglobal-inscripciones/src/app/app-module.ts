import { NgModule, provideBrowserGlobalErrorListeners } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RegistroModule } from './features/registro/registro-module';
import { AlumnosModule } from './features/alumnos/alumnos-module';
import { ResumenModule } from './features/resumen/resumen-module';

import { App } from './app';

@NgModule({
  declarations: [
    App
  ],
  imports: [
    BrowserModule,
    RegistroModule,
    AlumnosModule,
    ResumenModule
  ],
  providers: [
    provideBrowserGlobalErrorListeners(),
  ],
  bootstrap: [App]
})
export class AppModule { }
