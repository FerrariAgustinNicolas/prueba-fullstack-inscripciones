import { EstatusAlumno } from './estatus.model';
import { HistorialEstatus } from './historial-estatus.model';

export interface Alumno {
  id: number;
  nombre: string;
  empresa: string;
  programaId: number;
  programa: string;
  estatusActual: EstatusAlumno;
  fechaInscripcion: string;
  historial: HistorialEstatus[];
}