import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistroAlumno } from './registro-alumno';

describe('RegistroAlumno', () => {
  let component: RegistroAlumno;
  let fixture: ComponentFixture<RegistroAlumno>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [RegistroAlumno],
    }).compileComponents();

    fixture = TestBed.createComponent(RegistroAlumno);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
