import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegistroAlumno } from './registro-alumno/registro-alumno';

@NgModule({
  declarations: [RegistroAlumno],
  imports: [CommonModule],
  exports: [RegistroAlumno],
})
export class RegistroModule {}
