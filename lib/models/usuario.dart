class Usuario {
  final String nome;
  final String endereco;
  final String celular;
  final String dataDeNascimento;
  final String cpf;
  final String email;
  final String senha;
  final String category;

  Usuario({
    this.nome,
    this.endereco,
    this.celular,
    this.dataDeNascimento,
    this.cpf,
    this.email,
    this.senha,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'endereco': endereco,
      'celular': celular,
      'dataDeNascimento': dataDeNascimento,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'categoria' : category,
    };
  }
}
