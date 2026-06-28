import { EstatusAlumno } from './estatus.model';

export interface HistorialEstatus {
  id: number;
  alumnoId: number;
  estatusAnterior: EstatusAlumno | null;
  estatusNuevo: EstatusAlumno;
  fechaCambio: string;
  motivo: string;
}