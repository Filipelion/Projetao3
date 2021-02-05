class Servico {
  String tipo, descricao;
  num valorMedio;
  Map imagens;

  Servico({this.tipo, this.descricao, this.valorMedio, this.imagens});

  Servico.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    this.tipo = json["tipo"] ?? "";
    this.descricao = json["descricao"] ?? "";
    this.valorMedio = json["valorMedio"] ?? "";
    this.imagens = json["imagens"] ?? {};
  }

  Map<String, dynamic> toJson() => {
        "tipo": this.tipo,
        "descricao": this.descricao,
        "valorMedio": this.valorMedio,
        "imagens": this.imagens,
      };
}

class CartaServicos {
  String id;
  Map<String, dynamic> cartaServicos;

  CartaServicos({this.id, this.cartaServicos});

  Map<String, dynamic> get() {
    return this.cartaServicos;
  }

  Map save(String tipo, Map<String, dynamic> data) {
    this.cartaServicos[tipo] = data;
    return this.cartaServicos;
  }

  Map remove(String tipo) {
    cartaServicos.remove(tipo);
    return this.cartaServicos;
  }

  List tipos() {
    return cartaServicos.keys.toList();
  }
}