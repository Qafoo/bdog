define(
  ["jquery"],
  (jQuery) ->
    # Visitor, which generates a DefinitionList (dl,dt,dd) structure out of the
    # given JSON data
    class DefinitionListVisitor
      # Visit a JSON document root
      visit: (document) ->
        console.log("Document: ", document)
        jQuery("<dl />",
          class: "document"
        ).append(
          jQuery("<dd />").append(
            @visitDocumentType_(document)
          )
        )

      # Visit an aribtrary JSON document type
      visitDocumentType_: (document) ->
        switch
          when typeof document == "string"
            @visitString_ document
          when typeof document == "number"
            @visitNumber_ document
          when typeof document == "boolean"
            @visitBoolean_ document
          when document == undefined
            @visitUndefined_ document
          when document == null
            @visitNull_ document
          when typeof document == "object" and [].constructor == document.constructor
            @visitArray_ document
          when typeof document == "object"
            @visitObject_ document
          else
            console.warn("Unknown data type detected:", document);
            jQuery("<dd />",
              class: "unknown"
              text: JSON.stringify(document)
            )

      # Visit a string
      visitString_: (document) ->
        console.log("String: ", document)
        jQuery("<dl />",
          class: "string"
        ).append(
          jQuery("<dt />",
            text: "String (#{document.length})"
          )
        ).append(
          jQuery("<dd />",
            text: document
          )
        )

      # Visit a number
      visitNumber_: (document) ->
        console.log("Number: ", document)
        jQuery("<dl />",
          class: "number"
        ).append(
          jQuery("<dt />",
            text: "Number"
          )
        ).append(
          jQuery("<dd />",
            text: document.toString()
          )
        )

      # Visit a boolean
      visitBoolean_: (document) ->
        console.log("Boolean: ", document)
        jQuery("<dl />",
          class: "boolean"
        ).append(
          jQuery("<dt />",
            text: "Boolean"
          )
        ).append(
          jQuery("<dd />",
            text: document.toString()
          )
        )

      # Visit an undefined
      visitUndefined_: (document) ->
        console.log("Undefined: ", document)
        jQuery("<dl />",
          class: "undefined"
        ).append(
          jQuery("<dt />",
            text: "undefined"
          )
        ).append(
          jQuery("<dd />",
            text: "undefined"
          )
        )

      # Visit a null
      visitNull_: (document) ->
        console.log("Null: ", document)
        jQuery("<dl />",
          class: "null"
        ).append(
          jQuery("<dt />",
            text: "null"
          )
        ).append(
          jQuery("<dd />",
            text: "null"
          )
        )

      # Visit an array
      visitArray_: (document) ->
        console.log("Array: ", document)
        jQuery("<dl />",
          class: "array"
        ).append(
          jQuery("<dt />",
            text: "Array (#{document.length})"
          )
        ).append(document.map (item) =>
          jQuery("<dd />").append(
            @visitDocumentType_(item)
          )
        )

      # Visit an Object
      visitObject_: (document) ->
        console.log("Object: ", document)
        objectContainer = jQuery("<dl />",
          class: "object"
        ).append(
          jQuery("<dt />",
            text: "Object (#{Object.keys(document).length})"
          )
        )

        for key, value of document
          objectContainer.append(
            jQuery("<dd />").append(
              @visitKeyValue_(key, value)
            )
          )

        return objectContainer

      visitKeyValue_: (key, value) ->
        jQuery("<dl />",
          class: "key-value"
        ).append(
          jQuery("<dt />",
            text: key
          )
        ).append(
          jQuery("<dd />").append(
            @visitDocumentType_(value)
          )
        )
)