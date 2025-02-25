import Foundation

public struct MediaStream {
    public enum `Type`: String {
        case unknown = "Unknown"
        case audio = "Audio"
        case video = "Video"
        case subtitle = "Subtitle"
        case embeddedImage = "EmbeddedImage"
        case attachment = "Attachment"
        case data = "Data"
    }

    public let codec: String
    public let title: String?
    public let extradata: String?
    public let index: Int32
    public let isExternal: Bool
    public let type: `Type`
}

extension MediaStream {
    static func convertFromOpenAPI(_ mediaStream: Components.Schemas.MediaStream) -> MediaStream {
        MediaStream(
            codec: mediaStream.Codec ?? "",
            title: mediaStream.Title,
            extradata: mediaStream.Extradata,
            index: mediaStream.Index ?? -1,
            isExternal: mediaStream.IsExternal ?? false,
            type: mediaStream._Type.map { type in
                switch type {
                case .Unknown: .unknown
                case .Audio: .audio
                case .Video: .video
                case .Subtitle: .subtitle
                case .EmbeddedImage: .embeddedImage
                case .Attachment: .attachment
                case .Data: .data
                }
            } ?? .unknown
        )
    }
}
