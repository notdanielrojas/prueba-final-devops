const express = require("express");
const app = express();
const port = 3000;

app.use(express.json());

let pacientes = [
  { id: 1, nombre: "Maria Rodriguez", fechaNacimiento: "1980-05-10", telefono: "555-1234", etapa: 2 },
  { id: 2, nombre: "Pedro Gomez", fechaNacimiento: "1995-08-22", telefono: "555-5678", etapa: 1 },
  { id: 3, nombre: "Ana Perez", fechaNacimiento: "1975-03-15", telefono: "555-9012", etapa: 3 },
  { id: 4, nombre: "Juan Gonzalez", fechaNacimiento: "1988-11-05", telefono: "555-3456", etapa: 1 },
  { id: 5, nombre: "Sofia Sanchez", fechaNacimiento: "2000-07-28", telefono: "555-7890", etapa: 2 },
];

let citas = [
  {
    id: 1,
    pacienteId: 1,
    fecha: "2024-01-15",
    hora: "10:00",
    quiropractico: "Dra. Yosselyn Pérez",
    servicio: "Ajuste quiropráctico",
    notas: "Primera consulta",
  },
  {
    id: 2,
    pacienteId: 2,
    fecha: "2024-01-20",
    hora: "15:30",
    quiropractico: "Dra. Yosselyn Pérez",
    servicio: "Terapia de masaje",
    notas: "Sesión de seguimiento",
  },
  {
    id: 3,
    pacienteId: 3,
    fecha: "2024-01-22",
    hora: "09:00",
    quiropractico: "Dra. Yosselyn Pérez",
    servicio: "Ajuste quiropráctico",
    notas: "Control mensual",
  },
  {
    id: 4,
    pacienteId: 1,
    fecha: "2024-01-29",
    hora: "11:00",
    quiropractico: "Dra. Yosselyn Pérez",
    servicio: "Terapia de masaje",
    notas: "Sesión de seguimiento",
  },
  {
    id: 5,
    pacienteId: 4,
    fecha: "2024-02-05",
    hora: "14:00",
    quiropractico: "Dra. Yosselyn Pérez",
    servicio: "Evaluación inicial",
    notas: "Nueva lesión",
  },
];

// Obtener todos los pacientes
app.get("/pacientes", (req, res) => {
  res.json(pacientes);
});

// Obtener un paciente por ID
app.get("/pacientes/:id", (req, res) => {
  const pacienteId = parseInt(req.params.id);
  const paciente = pacientes.find((p) => p.id === pacienteId);
  if (paciente) {
    res.json(paciente);
  } else {
    res.status(404).send("Paciente no encontrado");
  }
});

// Crear un nuevo paciente
app.post("/pacientes", (req, res) => {
  const nuevoPaciente = req.body;
  nuevoPaciente.id = pacientes.length + 1;
  pacientes.push(nuevoPaciente);
  res.status(201).json(nuevoPaciente);
});

// Obtener todas las citas
app.get("/citas", (req, res) => {
  res.json(citas);
});

// Obtener una cita por ID
app.get("/citas/:id", (req, res) => {
  const citaId = parseInt(req.params.id);
  const cita = citas.find((c) => c.id === citaId);
  if (cita) {
    res.json(cita);
  } else {
    res.status(404).send("Cita no encontrada");
  }
});

// Crear una nueva cita
app.post("/citas", (req, res) => {
  const nuevaCita = req.body;
  nuevaCita.id = citas.length + 1;
  citas.push(nuevaCita);
  res.status(201).json(nuevaCita);
});

// Ruta para obtener las citas de un paciente por su ID
app.get("/pacientes/:id/citas", (req, res) => {
  const pacienteId = parseInt(req.params.id);
  const citasPaciente = citas.filter((c) => c.pacienteId === pacienteId);
  res.json(citasPaciente);
});

// Ruta de bienvenida
app.get("/", (req, res) => {
  res.send("Bienvenido al servidor de Yossequiropractica!");
});

app.listen(port, () => {
  console.log(`Servidor de Yossequiropractica escuchando en el puerto ${port}`);
});
