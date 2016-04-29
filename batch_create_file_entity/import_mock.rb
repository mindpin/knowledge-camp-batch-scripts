upload_files_dir = File.expand_path("../upload_files", __FILE__)

config = FilePartUpload.file_part_upload_config
config.delete :qiniu_audio_and_video_transcode
FilePartUpload.instance_variable_set(:@file_part_upload_config, config)

def mp4_params(original_name, key)
  {
    bucket:                  FilePartUpload.get_qiniu_bucket,
    token:                   key,
    file_size:               "1318081",
    image_rgb:               "",
    original:                original_name,
    mime:                    "video/mp4",
    image_width:             "",
    image_height:            "",
    avinfo_format:           "mov,mp4,m4a,3gp,3g2,mj2",
    avinfo_total_bit_rate:   "727217",
    avinfo_total_duration:   "14.500000",
    avinfo_video_codec_name: "h264",
    avinfo_video_bit_rate:   "532308",
    avinfo_video_duration:   "14.500000",
    avinfo_height:           "768",
    avinfo_width:            "1366",
    avinfo_audio_codec_name: "aac",
    avinfo_audio_bit_rate:   "192000",
    avinfo_audio_duration:   "14.421333"
  }
end

def jpg_params(original_name, key)
  {
    bucket:                  FilePartUpload.get_qiniu_bucket,
    token:                   key,
    file_size:               "87567",
    image_rgb:               "0xd0b6b2",
    original:                original_name,
    mime:                    "image/jpeg",
    image_width:             "1024",
    image_height:            "647",
    avinfo_format:           "jpeg_pipe",
    avinfo_total_bit_rate:   "",
    avinfo_total_duration:   "",
    avinfo_video_codec_name: "mjpeg",
    avinfo_video_bit_rate:   "",
    avinfo_video_duration:   "",
    avinfo_height:           "647",
    avinfo_width:            "1024",
    avinfo_audio_codec_name: "",
    avinfo_audio_bit_rate:   "",
    avinfo_audio_duration:   ""
  }
end

def png_params(original_name, key)
  {
    bucket:                  FilePartUpload.get_qiniu_bucket,
    token:                   key,
    file_size:               "101103",
    image_rgb:               "0xf8f8f8",
    original:                original_name,
    mime:                    "image/png",
    image_width:             "1364",
    image_height:            "1221",
    avinfo_format:           "png_pipe",
    avinfo_total_bit_rate:   "",
    avinfo_total_duration:   "",
    avinfo_video_codec_name: "png",
    avinfo_video_bit_rate:   "",
    avinfo_video_duration:   "",
    avinfo_height:           "1221",
    avinfo_width:            "1364",
    avinfo_audio_codec_name: "",
    avinfo_audio_bit_rate:   "",
    avinfo_audio_duration:   ""
  }
end

def normal_params(original_name, key)
  {
    bucket:                  FilePartUpload.get_qiniu_bucket,
    token:                   key,
    file_size:               "819",
    image_rgb:               "",
    original:                original_name,
    mime:                    "text/plain",
    image_width:             "",
    image_height:            "",
    avinfo_format:           "",
    avinfo_total_bit_rate:   "",
    avinfo_total_duration:   "",
    avinfo_video_codec_name: "",
    avinfo_video_bit_rate:   "",
    avinfo_video_duration:   "",
    avinfo_height:           "",
    avinfo_width:            "",
    avinfo_audio_codec_name: "",
    avinfo_audio_bit_rate:   "",
    avinfo_audio_duration:   ""
  }
end


Dir["#{upload_files_dir}/*"].each do |file_path|
  ext = File.extname(file_path)
  key = File.join(FilePartUpload.get_qiniu_base_path, "#{randstr}#{ext}")
  original_name = File.basename(file_path)

  result = case ext
  when ".mp4"
    mp4_params(original_name, key)
  when ".jpg",".jpeg"
    jpg_params(original_name, key)
  when ".png"
    png_params(original_name, key)
  else
    normal_params(original_name, key)
  end


  FilePartUpload::FileEntity.from_qiniu_callback_body(result)
end
