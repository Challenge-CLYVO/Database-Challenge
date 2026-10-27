use("clyvo_vet");

// 1. todos os pets (so alguns campos)
print("--- 1. Todos os pets");
printjson(db.pets.find({}, { nome: 1, especie: 1, raca: 1 }).sort({ _id: 1 }).toArray());

// 2. prontuario completo de um pet: tudo numa unica leitura, sem JOIN
print("--- 2. Prontuario completo do Rex");
printjson(db.pets.findOne({ _id: 1 }));

// 3. filtro simples: so os gatos
print("--- 3. Gatos");
printjson(db.pets.find({ especie: "GATO" }, { nome: 1, raca: 1 }).toArray());

// 4. busca dentro de um objeto: pets do tutor pelo CPF
print("--- 4. Pets do tutor com CPF 22222222222");
printjson(db.pets.find({ "responsavel.cpf": "22222222222" }, { nome: 1, responsavel: 1 }).toArray());

// 5. busca dentro de uma lista: pets com lembrete pendente
print("--- 5. Pets com lembrete PENDENTE");
printjson(db.pets.find({ "lembretes.status": "PENDENTE" }, { nome: 1, lembretes: 1 }).sort({ _id: 1 }).toArray());

// 6. contagem: quantos cachorros
print("--- 6. Quantidade de cachorros");
print(db.pets.countDocuments({ especie: "CACHORRO" }));

// 7. agrupamento: quantidade de pets por especie (parecido com GROUP BY)
print("--- 7. Pets por especie");
printjson(db.pets.aggregate([
  { $group: { _id: "$especie", quantidade: { $sum: 1 } } }
]).toArray());

// 8. validacao: tentativa de inserir um pet sem os campos obrigatorios
print("--- 8. Teste da validacao");
try {
  db.pets.insertOne({ _id: 99, nome: "Pet sem especie" });
  print("Inserido (nao deveria)");
} catch (e) {
  print("Recusado pela validacao: " + e.errmsg);
}