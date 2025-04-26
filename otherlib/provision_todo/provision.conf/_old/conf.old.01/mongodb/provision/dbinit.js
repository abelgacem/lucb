// Define > Var

Db = {
    Name: 'Topix'
  }
    
  Collection = {
    Name: {
            Domain : 'Domain',
            Topic  : 'Topic',
            Folder : 'Folder'
     }
  }
    
  // Connect > to > Db.Local
  conn    = Mongo();
  
  // Define > Db.Current
  db = conn.getDB(Db.Name);
  
  // Remove > Collection > If > Exist
  db.getCollection(Collection.Name.Domain).drop()
  db.getCollection(Collection.Name.Topic).drop()
  db.getCollection(Collection.Name.Folder).drop()
  
  // Create Collection
  db.createCollection(Collection.Name.Domain)
  db.createCollection(Collection.Name.Topic)
  db.createCollection(Collection.Name.Folder)
  
  // Add > Collection:Domain:Document
  Document = {
      'Name':'Base',
      'Desc':'Common > to > Topic.All'
  }
  db.getCollection(Collection.Name.Domain).insert(Document)
  Document = {
      'Name':'Math',
      'Desc':'Specific > to > Topic.Math'
  }
  db.getCollection(Collection.Name.Domain).insert(Document)
  Document = {
      'Name':'Language',
      'Desc':'Specific > to > Topic.Language'
  }
  db.getCollection(Collection.Name.Domain).insert(Document)
  
  // Add > Collection:Topic:Document
  Document = {
    'Name'   : 'template',
    'Domain' : 'Base',
    'Desc'   : 'Template > for > Topic.All',
    'Member' : {
        'List': [
            {'Name':'README.md', 'Type':'File'},
            {'Name':'list',      'Type':'Folder'},
            {'Name':'howto',     'Type':'Folder'},
            {'Name':'whatis',    'Type':'Folder'},
        ]
    }
  }
  db.getCollection(Collection.Name.Topic).insert(Document)
  
  // Add > Collection:Folder:Document
  Document = {
    'Name'   : 'list',
    'Desc'   : 'Template > for > Folder:list',
    'Member' : {
        'Link': {
            'Dst' : 'readme.md',
            'Src' : 'list_list.md'
        },
        'List': [
            {'Name':'list_list.md',    'Type':'File' },
            {'Name':'howto_list.md',   'Type':'File' },
            {'Name':'acronym_list.md', 'Type':'File' },
            {'Name':'whatis_list.md',  'Type':'File' },
        ]
    }
  }
  db.getCollection(Collection.Name.Folder).insert(Document)
  Document = {
    'Name'   : 'howto',
    'Desc'   : 'Template > for > Folder:howto',
    'Member' : {
        'Link': {
            'Dst' : 'readme.md',
            'Src' : 'list_howto.md'
        },
        'List': [
        {'Name':'template_whatis.md',    'Type':'File' }
        ]
    }
  }
  db.getCollection(Collection.Name.Folder).insert(Document)
  Document = {
      'Name'   : 'howto',
      'Desc'   : 'Template > for > Folder:whatis',
      'Member' : {
          'Link': {
              'Dst' : 'readme.md',
              'Src' : 'list_whatis.md'
          },
          'List': [
            {'Name':'template_whatis.md',    'Type':'File' }
          ]
      }
  }
  db.getCollection(Collection.Name.Folder).insert(Document)
  