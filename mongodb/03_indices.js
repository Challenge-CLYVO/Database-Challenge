use("clyvo_vet");

// busca de pets por especie (ex.: todos os gatos)
db.pets.createIndex({ especie: 1 });

// busca dos pets de um tutor pelo CPF (campo dentro do objeto responsavel)
db.pets.createIndex({ "responsavel.cpf": 1 });

// busca de lembretes pendentes (campo dentro da lista lembretes)
db.pets.createIndex({ "lembretes.status": 1 });

// mostra os indices criados
printjson(db.pets.getIndexes());