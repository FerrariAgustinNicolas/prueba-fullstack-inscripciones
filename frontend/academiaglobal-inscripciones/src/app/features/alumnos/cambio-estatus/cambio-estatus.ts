import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Observable } from 'rxjs';

import { Alumno, EstatusAlumno, HistorialEstatus } from '../../../models';
import { AlumnoService } from '../../../services/alumno.service';

@Component({
  selector: 'app-cambio-estatus',
  standalone: false,
  templateUrl: './cambio-estatus.html',
  styleUrl: './cambio-estatus.css',
})
export class CambioEstatus {
  alumnos$: Observable<Alumno[]>;
  form: FormGroup;

  alumnoSeleccionado?: Alumno;
  historialSeleccionado: HistorialEstatus[] = [];

  mensajeExito = '';
  mensajeError = '';

  estatusOpciones: EstatusAlumno[] = [
    'activo',
    'baja_empresa',
    'baja_programa',
    'inscrito',
    'suspendido',
    'reingreso',
    'egresado',
  ];

  constructor(
    private fb: FormBuilder,
    private alumnoService: AlumnoService
  ) {
    this.alumnos$ = this.alumnoService.alumnos$;

    this.form = this.fb.group({
      alumnoId: [null as number | null, Validators.required],
      nuevoEstatus: ['' as EstatusAlumno | '', Validators.required],
      motivo: ['', [Validators.required, Validators.minLength(5)]],
    });
  }

  onSeleccionarAlumno(): void {
    const alumnoId = this.form.value.alumnoId;

    this.mensajeExito = '';
    this.mensajeError = '';

    if (!alumnoId) {
      this.alumnoSeleccionado = undefined;
      this.historialSeleccionado = [];
      return;
    }

    this.actualizarAlumnoSeleccionado(alumnoId);

    this.form.patchValue({
      nuevoEstatus: '',
    });
  }

  registrarCambio(): void {
    this.mensajeExito = '';
    this.mensajeError = '';

    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    const alumnoId = this.form.value.alumnoId;
    const nuevoEstatus = this.form.value.nuevoEstatus;
    const motivo = this.form.value.motivo ?? '';

    if (!alumnoId || !nuevoEstatus) {
      return;
    }

    const resultado = this.alumnoService.cambiarEstatus(
      alumnoId,
      nuevoEstatus as EstatusAlumno,
      motivo
    );

    if (!resultado.ok) {
      this.mensajeError = resultado.mensaje;
      return;
    }

    this.mensajeExito = resultado.mensaje;

    this.form.reset({
      alumnoId,
      nuevoEstatus: '',
      motivo: '',
    });

    this.actualizarAlumnoSeleccionado(alumnoId);

    this.form.markAsPristine();
    this.form.markAsUntouched();
  }

  obtenerEtiquetaEstatus(estatus: EstatusAlumno): string {
    const etiquetas: Record<EstatusAlumno, string> = {
      activo: 'Activo',
      baja_empresa: 'Baja de empresa',
      baja_programa: 'Baja del programa',
      inscrito: 'Inscrito',
      suspendido: 'Suspendido',
      reingreso: 'Reingreso',
      egresado: 'Egresado',
    };

    return etiquetas[estatus];
  }

  obtenerEtiquetaEstatusAnterior(estatus: EstatusAlumno | null): string {
    if (!estatus) {
      return 'Sin estatus anterior';
    }

    return this.obtenerEtiquetaEstatus(estatus);
  }

  campoInvalido(nombreCampo: 'alumnoId' | 'nuevoEstatus' | 'motivo'): boolean {
    const campo = this.form.get(nombreCampo);
    return !!campo && campo.invalid && (campo.dirty || campo.touched);
  }

  private actualizarAlumnoSeleccionado(alumnoId: number): void {
    this.alumnoSeleccionado = this.alumnoService.obtenerAlumnoPorId(alumnoId);

    this.historialSeleccionado = [
      ...(this.alumnoSeleccionado?.historial ?? []),
    ].reverse();
  }
}