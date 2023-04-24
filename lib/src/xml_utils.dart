import 'dart:mirrors';

import 'package:xml/xml.dart';

extension XmlElementUtils on XmlElement {
  List<T> loadList<T>(String name, T Function(XmlElement) create) {
    var xmlList = getElement(name);
    List<T> list = <T>[];
    if (xmlList != null) {
      for (var info in xmlList.childElements) {
        list.add(create(info));
      }
    }
    return list;
  }

  void loadProperties<T>(T t) {
    var reflectee = reflect(t);
    ClassMirror classMirror = reflectClass(XmlProperty);

    for (var value in reflectee.type.declarations.values) {
      for (var metadata in value.metadata) {
        if (metadata.type != classMirror) continue;

        XmlProperty r = metadata.reflectee;
        var name = MirrorSystem.getName(value.simpleName);

        XmlElement? element = getElement(r.propertyName ?? name);
        var text = element?.text;

        reflectee.setField(value.simpleName, text);
      }
    }
  }
}

class XmlProperty {
  final String? propertyName;

  const XmlProperty([this.propertyName]);
}