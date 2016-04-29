upload_files_dir = File.expand_path("../upload_files", __FILE__)

require 'rest-client'
RestClient::Payload::Multipart.class_eval do
  def mime_for(path)
    case File.extname(path)
    when ".mp4"
      return "video/mp4"
    else
      super
    end
  end
end


Dir["#{upload_files_dir}/*"].each do |file_path|
  ext = File.extname(file_path)
  key = File.join(FilePartUpload.get_qiniu_base_path, "#{randstr}#{ext}")
  original_name = File.basename(file_path)

  put_policy = Qiniu::Auth::PutPolicy.new(FilePartUpload.get_qiniu_bucket,key, 3600000)

  put_policy.return_body = '{
    "bucket"                 : $(bucket),
    "token"                  : $(key),
    "file_size"              : $(fsize),
    "image_rgb"              : $(imageAve.RGB),
    "original"               : $(x:original),
    "mime"                   : $(mimeType),
    "image_width"            : $(imageInfo.width),
    "image_height"           : $(imageInfo.height),
    "avinfo_format"          : $(avinfo.format.format_name),
    "avinfo_total_bit_rate"  : $(avinfo.format.bit_rate),
    "avinfo_total_duration"  : $(avinfo.format.duration),
    "avinfo_video_codec_name": $(avinfo.video.codec_name),
    "avinfo_video_bit_rate"  : $(avinfo.video.bit_rate),
    "avinfo_video_duration"  : $(avinfo.video.duration),
    "avinfo_height"          : $(avinfo.video.height),
    "avinfo_width"           : $(avinfo.video.width),
    "avinfo_audio_codec_name": $(avinfo.audio.codec_name),
    "avinfo_audio_bit_rate"  : $(avinfo.audio.bit_rate),
    "avinfo_audio_duration"  : $(avinfo.audio.duration)
  }'

  #生成上传 Token
  uptoken = Qiniu::Auth.generate_uptoken(put_policy)

  #要上传文件的本地路径
  filePath = File.expand_path(file_path, __FILE__)

  #调用upload_with_token_2方法上传
  code, result, response_headers = Qiniu::Storage.upload_with_token_2(
       uptoken,
       filePath,
       key
  )

  result["original"] = original_name
  new_result = {}
  result.each do |key, value|
    value = "" if value.nil?
    new_result[key.to_sym] = value
  end
p result
  FilePartUpload::FileEntity.from_qiniu_callback_body(new_result)
end
