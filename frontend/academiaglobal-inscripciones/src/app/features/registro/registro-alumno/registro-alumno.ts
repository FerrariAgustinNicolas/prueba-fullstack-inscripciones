import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs';

import { Programa } from '../../../models';
import { AlumnoService } from '../../../services/alumno.service';

@Component({
  selector: 'app-registro-alumno',
  standalone: false,
  templateUrl: './registro-alumno.html',
  styleUrl: './registro-alumno.css',
})
export class RegistroAlumno {
  registroForm: FormGroup;
  programas$: Observable<Programa[]>;

  constructor(
    private formBuilder: FormBuilder,
    private alumnoService: AlumnoService
  ) {
    this.programas$ = this.alumnoService.programas$;

    this.registroForm = this.formBuilder.group({
      nombre: ['', [Validators.required, Validators.minLength(3)]],
      empresa: ['', Validators.required],
      programaId: ['', Validators.required],
      fechaInscripcion: ['', Validators.required],
    });
  }

  registrarAlumno(): void {
    if (this.registroForm.invalid) {
      this.registroForm.markAllAsTouched();
      return;
    }

    const { nombre, empresa, programaId, fechaInscripcion } = this.registroForm.value;
    const programas = this.alumnoService.obtenerProgramas();
    const programaSeleccionado = programas.find(
      (programa) => programa.id === Number(programaId)
    );

    if (!programaSeleccionado) {
      return;
    }

    this.alumnoService.agregarAlumno({
      nombre: nombre.trim(),
      empresa: empresa.trim(),
      programaId: programaSeleccionado.id,
      programa: programaSeleccionado.nombre,
      fechaInscripcion,
    });

    this.registroForm.reset();
  }

  campoInvalido(campo: string): boolean {
    const control = this.registroForm.get(campo);
    return !!control && control.invalid && (control.dirty || control.touched);
  }
}