import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AlumnosListado } from './alumnos-listado';

describe('AlumnosListado', () => {
  let component: AlumnosListado;
  let fixture: ComponentFixture<AlumnosListado>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AlumnosListado],
    }).compileComponents();

    fixture = TestBed.createComponent(AlumnosListado);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
