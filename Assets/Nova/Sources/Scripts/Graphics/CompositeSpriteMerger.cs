using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;

namespace Nova
{
    public class CompositeSpriteMerger : MonoBehaviour
    {
        private const int MergerLayer = 16;

        private MeshRenderer meshRenderer = null;
        private MeshFilter meshFilter = null;

        public int spriteCount { get; private set; }

        private void EnsureRenderer(int count)
        {
            if (!meshRenderer)
            {
                var go = new GameObject("MergingSprite");
                go.transform.SetParent(transform, false);
                go.layer = MergerLayer;
                var mr = go.AddComponent<MeshRenderer>();
                mr.sharedMaterial = new Material(Shader.Find("Sprites/Merge"));
                var mf = go.AddComponent<MeshFilter>();
                mf.mesh = null;
                go.transform.localScale = new Vector3 (0.01f, 0.01f, 0.01f);
                meshRenderer = mr;
                meshFilter = mf;
            }

            meshRenderer.gameObject.SetActive(0 < count);

            spriteCount = count;
        }

        public void SetTextures(IReadOnlyList<SpriteWithOffset> sprites)
        {
            if (sprites == null)
            {
                EnsureRenderer(0);
                return;
            }

            EnsureRenderer(sprites.Count);
            int validSprites = 0;
            var bounds = GetMergedSize(sprites);
            if (bounds.size.x > 0 && bounds.size.y > 0)
            {
                var mesh = new Mesh();
                mesh.name = "CompositeSpriteMesh";
                mesh.vertices = new Vector3[4]
                {
                    new Vector3(bounds.xMin, bounds.yMin, 0),
                    new Vector3(bounds.xMax, bounds.yMin, 0),
                    new Vector3(bounds.xMax, bounds.yMax, 0),
                    new Vector3(bounds.xMin, bounds.yMax, 0),
                };
                mesh.uv = new Vector2[4]
                {
                    new Vector2(0, 0),
                    new Vector2(1, 0),
                    new Vector2(1, 1),
                    new Vector2(0, 1),
                };
                mesh.SetIndices(new int[]{0, 1, 2, 0, 2, 3}, MeshTopology.Triangles, 0);
                meshFilter.mesh = mesh;
            }
            for (var i = 0; i < sprites.Count; i++)
            {
                var sprite = sprites[i];

                float pixelPerUnit = sprite.sprite.pixelsPerUnit;
                float scaleX = bounds.size.x / sprite.sprite.texture.width;
                float scaleY = bounds.size.y / sprite.sprite.texture.height;
                float offsetX = (sprite.offset.x * pixelPerUnit - sprite.sprite.texture.width /2f - bounds.xMin) / bounds.size.x;
                float offsetY = (sprite.offset.y * pixelPerUnit - sprite.sprite.texture.height / 2f - bounds.yMin) / bounds.size.y;
                meshRenderer.sharedMaterial.SetTexture("_MainTex" + validSprites, sprite.sprite.texture);
                meshRenderer.sharedMaterial.SetVector("_MainTex" + validSprites + "_ST", new Vector4(scaleX, scaleY, -offsetX * scaleX, -offsetY * scaleY));

                validSprites++;
            }
            meshRenderer.sharedMaterial.EnableKeyword("TEX" + validSprites);
        }

        public void SetTextures(CompositeSpriteMerger other)
        {
            EnsureRenderer(other.spriteCount);
            if (other.spriteCount > 0)
            {
                meshFilter.mesh = other.meshFilter.mesh;
                meshRenderer.sharedMaterial.CopyPropertiesFromMaterial(other.meshRenderer.sharedMaterial);
            }
        }

        private void ClearTextures()
        {
            SetTextures(Array.Empty<SpriteWithOffset>());
        }

        public void Render(CommandBuffer cmd, int rt)
        {
            cmd.SetRenderTarget(rt);
            cmd.ClearRenderTarget(true, true, Color.clear);
            if (!isActiveAndEnabled)
            {
                return;
            }

            if (spriteCount > 0)
            {
                cmd.DrawRenderer(meshRenderer, meshRenderer.sharedMaterial);
            }
        }

        public void RenderToTexture(IReadOnlyList<SpriteWithOffset> sprites, Camera renderCamera, Rect bounds,
            RenderTexture target)
        {
            SetTextures(sprites);
            var height = Mathf.Max(bounds.height, bounds.width / target.width * target.height);

            renderCamera.targetTexture = target;
            renderCamera.orthographicSize = height / 2 * renderCamera.transform.lossyScale.y;
            renderCamera.transform.localPosition = new Vector3(bounds.center.x, bounds.center.y, 0);

            renderCamera.Render();
            ClearTextures();
        }

        public RenderTexture RenderToTexture(IReadOnlyList<SpriteWithOffset> sprites, Camera renderCamera)
        {
            var bounds = GetMergedSize(sprites);
            var size = bounds.size;
            var renderTexture = new RenderTexture((int)size.x, (int)size.y, 0, RenderTextureFormat.ARGB32);

            RenderToTexture(sprites, renderCamera, bounds, renderTexture);
            return renderTexture;
        }

        public static Rect GetMergedSize(IEnumerable<SpriteWithOffset> spriteList)
        {
            var sprites = spriteList.Where(x => x != null).ToList();
            if (!sprites.Any())
            {
                return Rect.zero;
            }

            var xMin = float.MaxValue;
            var yMin = float.MaxValue;
            var xMax = float.MinValue;
            var yMax = float.MinValue;
            foreach (var sprite in sprites)
            {
                var bounds = sprite.sprite.bounds;
                var pixelsPerUnit = sprite.sprite.pixelsPerUnit;
                var center = (bounds.center + sprite.offset) * pixelsPerUnit;
                var extents = bounds.extents * pixelsPerUnit;
                xMin = Mathf.Min(xMin, center.x - extents.x);
                yMin = Mathf.Min(yMin, center.y - extents.y);
                xMax = Mathf.Max(xMax, center.x + extents.x);
                yMax = Mathf.Max(yMax, center.y + extents.y);
            }

            return Rect.MinMaxRect(xMin, yMin, xMax, yMax);
        }

#if UNITY_EDITOR
        public static GameObject InstantiateSimpleSpriteMerger(string name, out Camera renderCamera,
            out CompositeSpriteMerger merger)
        {
            var root = new GameObject(name)
            {
                hideFlags = HideFlags.DontSave
            };
            merger = root.Ensure<CompositeSpriteMerger>();
            merger.runInEditMode = true;

            var camera = new GameObject("Camera");
            camera.transform.SetParent(root.transform, false);
            renderCamera = camera.Ensure<Camera>();
            renderCamera.cullingMask = 1 << MergerLayer;
            renderCamera.orthographic = true;
            renderCamera.enabled = false;
            renderCamera.nearClipPlane = -1;
            renderCamera.farClipPlane = 1;
            renderCamera.clearFlags = CameraClearFlags.SolidColor;
            renderCamera.backgroundColor = Color.clear;

            return root;
        }
#endif
    }
}
