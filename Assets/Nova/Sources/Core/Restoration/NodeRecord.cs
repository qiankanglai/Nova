using System.Text;

namespace Nova
{
    public class NodeRecord
    {
        // 4 * sizeof(long) + 3 * sizeof(int)
        private const int HeaderSize = 4 * 8 + 3 * 4;

        public readonly long offset;
        public long parent;
        public long child;
        public long sibling; // please use more gender neutral names
        public readonly int beginDialogue;
        public int endDialogue;
        public int lastCheckpointDialogue;
        public readonly ulong variableHash;
        public readonly string name;

        // we need a fixed length serialization
        // maybe using a code generator?
        public ByteSegment ToByteSegment()
        {
            var buf = new byte[HeaderSize + Encoding.UTF8.GetByteCount(name)];
            var segment = new ByteSegment(buf);
            segment.WriteLong(0, parent);
            segment.WriteLong(8, child);
            segment.WriteLong(16, sibling);
            segment.WriteInt(24, beginDialogue);
            segment.WriteInt(28, endDialogue);
            segment.WriteInt(32, lastCheckpointDialogue);
            segment.WriteUlong(36, variableHash);
            segment.WriteString(HeaderSize, name);
            return segment;
        }

        public NodeRecord(long offset, string name, int beginDialogue, ulong variableHash)
        {
            this.offset = offset;
            this.name = name;
            this.beginDialogue = beginDialogue;
            endDialogue = beginDialogue;
            lastCheckpointDialogue = -1;
            this.variableHash = variableHash;
        }

        public NodeRecord(long offset, ByteSegment segment)
        {
            this.offset = offset;
            parent = segment.ReadLong(0);
            child = segment.ReadLong(8);
            sibling = segment.ReadLong(16);
            beginDialogue = segment.ReadInt(24);
            endDialogue = segment.ReadInt(28);
            lastCheckpointDialogue = segment.ReadInt(32);
            variableHash = segment.ReadUlong(36);
            name = segment.ReadString(HeaderSize);
        }
    }
}