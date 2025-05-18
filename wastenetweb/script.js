const provinsiMap = new Map();
const kabupatenMap = new Map();
const kecamatanMap = new Map();
const kelurahanMap = new Map();


window.addEventListener("DOMContentLoaded", () => {
  const provinsiSelect = document.getElementById("provinsi");
  const kabupatenSelect = document.getElementById("kabupaten");
  const kecamatanSelect = document.getElementById("kecamatan");
  const kelurahanSelect = document.getElementById("kelurahan");
  const monthInput = document.getElementById("month");

  // Set default bulan ke bulan ini
  const now = new Date();
  const year = now.getFullYear();
  const month = (now.getMonth() + 1).toString().padStart(2, '0');
  monthInput.value = `${year}-${month}`;

  // Ambil data provinsi dari API
  fetch("https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json")
  .then(response => response.json())
  .then(provinces => {
    provinces.forEach(provinsi => {
      const nameFormatted = toTitleCase(provinsi.name);
      provinsiMap.set(provinsi.id, nameFormatted);
      const option = document.createElement("option");
      option.value = provinsi.id;
      option.textContent = provinsi.name;
      provinsiSelect.appendChild(option);
    });
  })
    
  provinsiSelect.addEventListener("change", () => {
    const provinsiId = provinsiSelect.value;
  
    kabupatenSelect.innerHTML = '<option value="">Pilih Kabupaten/Kota</option>';
  
    if (!provinsiId) return;
  
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${provinsiId}.json`)
    .then(response => response.json())
    .then(regencies => {
      regencies.forEach(kabupaten => {
        const nameFormatted = toTitleCase(kabupaten.name);
        kabupatenMap.set(kabupaten.id, nameFormatted);
        const option = document.createElement("option");
        option.value = kabupaten.id;
        option.textContent = kabupaten.name;
        kabupatenSelect.appendChild(option);
      });
    });
  });

  kabupatenSelect.addEventListener("change", () => {
    const kabupatenId = kabupatenSelect.value;
  
    kecamatanSelect.innerHTML = '<option value="">Pilih kecamatan/Kota</option>';
  
    if (!kabupatenId) return;
  
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${kabupatenId}.json`)
    .then(response => response.json())
    .then(kecamatans => {
      kecamatans.forEach(kecamatan => {
        const nameFormatted = toTitleCase(kecamatan.name);
        kecamatanMap.set(kecamatan.id, nameFormatted);
        const option = document.createElement("option");
        option.value = kecamatan.id;
        option.textContent = kecamatan.name;
        kecamatanSelect.appendChild(option);
      });
    });
  });

  kecamatanSelect.addEventListener("change", () => {
    const kecamatanId = kecamatanSelect.value;
  
    kelurahanSelect.innerHTML = '<option value="">Pilih kelurahan/Kota</option>';
  
    if (!kecamatanId) return;
  
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${kecamatanId}.json`)
    .then(response => response.json())
    .then(kelurahans => {
      kelurahans.forEach(kelurahan => {
        const nameFormatted = toTitleCase(kelurahan.name);
        kelurahanMap.set(kelurahan.id, nameFormatted);
        const option = document.createElement("option");
        option.value = kelurahan.id;
        option.textContent = kelurahan.name;
        kelurahanSelect.appendChild(option);
      });
    });
   });
})

function toTitleCase(str) {
  return str
    .toLowerCase()
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}
  
function updateSummary() {
  const summaryTitle = document.getElementById("summary-title");

  const namaBulan = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember"
  ];

  const monthInput = document.getElementById("month").value;

  let bulan, tahun;
  if (monthInput) {
    [tahun, bulan] = monthInput.split("-");
    bulan = parseInt(bulan) - 1; // convert ke 0-based index
  } else {
    const now = new Date();
    bulan = now.getMonth();
    tahun = now.getFullYear();
  }

  // Ambil nilai lokasi
  const provinsi = document.getElementById("provinsi").value;
  const kabupaten = document.getElementById("kabupaten").value;
  const kecamatan = document.getElementById("kecamatan").value;
  const kelurahan = document.getElementById("kelurahan").value;

  let lokasi = "semua wilayah";
  if (provinsi || kabupaten || kecamatan || kelurahan) {
    lokasi = provinsiMap.get(provinsi) || "";
    if (kabupaten) lokasi += ", " + kabupatenMap.get(kabupaten);
    if (kecamatan) lokasi += ", " + kecamatanMap.get(kecamatan);
    if (kelurahan) lokasi += ", " + kelurahanMap.get(kelurahan);
  }

  summaryTitle.textContent = `Rangkuman data pada ${namaBulan[bulan]} ${tahun} untuk ${lokasi}`;
}

function getFilters() {
    const monthInput = document.getElementById("month").value;
  
    let bulan, tahun;
    if (monthInput) {
      [tahun, bulan] = monthInput.split("-");
    } else {
      const now = new Date();
      bulan = (now.getMonth() + 1).toString().padStart(2, "0"); // 1-based, format 2 digit
      tahun = now.getFullYear().toString();
    }
  
    const provinsi = document.getElementById("provinsi").value || "";
    const kabupaten = document.getElementById("kabupaten").value || "";
    const kecamatan = document.getElementById("kecamatan").value || "";
    const kelurahan = document.getElementById("kelurahan").value || "";
  
    return { tahun, bulan, provinsi, kabupaten, kecamatan, kelurahan };
}
  
function showList(type) {
    const filters = getFilters();
  
    // Encode URI komponen supaya aman di URL
    const params = new URLSearchParams({
      type,
      tahun: filters.tahun,
      bulan: filters.bulan,
      provinsi: filters.provinsi,
      kabupaten: filters.kabupaten,
      kecamatan: filters.kecamatan,
      kelurahan: filters.kelurahan,
    });
  
    // Contoh redirect ke halaman list.html dengan query params
    window.location.href = "list.html?" + params.toString();
}
  
const kategoriData = [
    { nama: "Plastik", jumlah: 120 },
    { nama: "Kertas", jumlah: 95 },
    { nama: "Logam", jumlah: 78 },
    { nama: "Kaca", jumlah: 65 },
    { nama: "Organik", jumlah: 60 },
    { nama: "Elektronik", jumlah: 48 },
    { nama: "Tekstil", jumlah: 44 },
    { nama: "Karet", jumlah: 39 },
    { nama: "Jelantah", jumlah: 33 },
    { nama: "Baterai", jumlah: 25 }
];

const nasabahData = [
    { nama: "Botol Plastik", jumlah: 110 },
    { nama: "Kardus", jumlah: 90 },
    { nama: "Kaleng", jumlah: 70 },
    { nama: "Kaca Pecah", jumlah: 55 },
    { nama: "Sisa Makanan", jumlah: 50 },
    { nama: "Kabel", jumlah: 43 },
    { nama: "Pakaian Bekas", jumlah: 38 },
    { nama: "Ban Bekas", jumlah: 32 },
    { nama: "Jelantah", jumlah: 30 },
    { nama: "Baterai Bekas", jumlah: 20 }
];

const tpsData = [
    { nama: "Plastik Campuran", jumlah: 130 },
    { nama: "Sampah Dapur", jumlah: 100 },
    { nama: "Kardus", jumlah: 88 },
    { nama: "Sampah Taman", jumlah: 75 },
    { nama: "Sampah Konstruksi", jumlah: 67 },
    { nama: "Elektronik Rusak", jumlah: 59 },
    { nama: "Botol Minuman", jumlah: 52 },
    { nama: "Styrofoam", jumlah: 46 },
    { nama: "Kertas", jumlah: 40 },
    { nama: "Sisa Makanan", jumlah: 36 }
];

function createHorizontalChart(ctxId, data, label) {
  const ctx = document.getElementById(ctxId).getContext("2d");
  new Chart(ctx, {
    type: "bar",
    data: {
      labels: data.map(d => d.nama),
      datasets: [{
        label: label,
        data: data.map(d => d.jumlah),
        backgroundColor: "#4caf50"
      }]
    },
    options: {
      indexAxis: 'y',
      responsive: true,
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          callbacks: {
            label: (context) => `${context.parsed.x} kg`
          }
        }
      },
      scales: {
        x: {
          title: {
            display: true,
            text: 'Jumlah (kg)'
          },
          beginAtZero: true
        }
      }
    }
  });
}

createHorizontalChart("kategoriChart", kategoriData, "Kategori Sampah (kg)");
createHorizontalChart("nasabahChart", nasabahData, "Produk Nasabah (kg)");
createHorizontalChart("tpsChart", tpsData, "Sampah TPS (kg)");

const allData = [
  {
    brand: "Brand A",
    bsu: { total: 100, nasabah: 60, tps: 40 },
    bsuOut: { total: 90, induk: 70, lain: 20 },
    bsi: { total: 120, fromUnit: 80, nasabah: 20, tps: 20 },
    bsiOut: 110
  },
  {
    brand: "Brand B",
    bsu: { total: 60, nasabah: 30, tps: 30 },
    bsuOut: { total: 50, induk: 40, lain: 10 },
    bsi: { total: 70, fromUnit: 50, nasabah: 10, tps: 10 },
    bsiOut: 65
  }
];

function filterData() {
  const keyword = document.getElementById("brandSearch").value.toLowerCase();
  const statsSection1 = document.getElementById("statsSection1");
  const statsSection2 = document.getElementById("statsSection2");
  const statsSection3 = document.getElementById("statsSection3");

  if (!keyword) {
    statsSection1.style.display = "none";
    statsSection2.style.display = "none";
    statsSection3.style.display = "none";
    return;
  }

  const data = allData.find(item => item.brand.toLowerCase().includes(keyword));

  if (!data) {
    alert("Data brand tidak ditemukan.");
    statsSection1.style.display = "none";
    statsSection2.style.display = "none";
    statsSection3.style.display = "none";
    return;
  }

  // Tampilkan section dan isi datanya
  statsSection1.style.display = "flex";
  statsSection2.style.display = "flex";
  statsSection3.style.display = "flex";

  document.getElementById("bsu-total").textContent = data.bsu.total + " kg";
  document.getElementById("bsu-nasabah").textContent = data.bsu.nasabah + " kg";
  document.getElementById("bsu-tps").textContent = data.bsu.tps + " kg";

  document.getElementById("bsu-out-total").textContent = data.bsuOut.total + " kg";
  document.getElementById("bsu-out-induk").textContent = data.bsuOut.induk + " kg";
  document.getElementById("bsu-out-lain").textContent = data.bsuOut.lain + " kg";

  document.getElementById("bsi-total").textContent = data.bsi.total + " kg";
  document.getElementById("bsi-unit").textContent = data.bsi.fromUnit + " kg";
  document.getElementById("bsi-nasabah").textContent = data.bsi.nasabah + " kg";
  document.getElementById("bsi-tps").textContent = data.bsi.tps + " kg";

  document.getElementById("bsi-out-total").textContent = data.bsiOut + " kg";
}