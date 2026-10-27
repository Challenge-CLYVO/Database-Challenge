// cria (ou usa) o banco clyvo_vet
use("clyvo_vet");

// apaga a colecao se ja existir, para poder rodar o script de novo
db.pets.drop();

// cria a colecao pets com regras de validacao
db.createCollection("pets", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "nome", "sexo", "especie", "responsavel"],
      properties: {
        _id:     { bsonType: "int" },
        nome:    { bsonType: "string" },
        sexo:    { enum: ["MACHO", "FEMEA", "NAO_INFORMADO"] },
        raca:    { bsonType: "string" },
        especie: { bsonType: "string" },
        data_nascimento: { bsonType: "string" },
        responsavel: {
          bsonType: "object",
          required: ["nome", "cpf"],
          properties: {
            nome: { bsonType: "string" },
            cpf:  { bsonType: "string" }
          }
        },
        consultas: { bsonType: "array" },
        vacinas:   { bsonType: "array" },
        lembretes: { bsonType: "array" }
      }
    }
  }
});

print("Colecao pets criada.");