import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegistroAlumno } from './registro-alumno/registro-alumno';
import { ReactiveFormsModule } from '@angular/forms';

@NgModule({
  declarations: [RegistroAlumno],
  imports: [CommonModule, ReactiveFormsModule],
  exports: [RegistroAlumno],
})
export class RegistroModule {}
