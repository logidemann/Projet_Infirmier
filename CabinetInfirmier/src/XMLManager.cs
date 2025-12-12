namespace Fragmentum.Data.Tools;

using System.IO;
using System.Xml.Serialization;

public class XmlManager<T>
{
    /**
     * loads a generic T variable of the type to be deserialized to store
     * the deserialized xml file
     */
    public T Load(string path)
    {
        T instance;

        // reads the text (xml) file and store in reader
        using (TextReader reader = new StreamReader(path))
        {
            // create an instance of the XmlSerializer
            XmlSerializer xml = new XmlSerializer(typeof(T));

            // deserialize and casts the text into the type T
            instance = (T)xml.Deserialize(reader);
        }
        return instance;
    }

    /**
     * returns the document as a serialized object of type T
     * return _instance;
     */
    public void Save(string path, object obj)
    {
        using (TextWriter writer = new StreamWriter(path))
        {
            XmlSerializer xml = new XmlSerializer(typeof(T));
            xml.Serialize(writer, obj);
        }
    }

    public void Save(string path, object obj, XmlSerializerNamespaces ns)
    {
        using (TextWriter writer = new StreamWriter(path))
        {
            XmlSerializer xml = new XmlSerializer(typeof(T));
            xml.Serialize(writer, obj, ns);
        }
    }
}